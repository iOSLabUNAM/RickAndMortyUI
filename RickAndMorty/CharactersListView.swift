//
//  CharactersListView.swift
//  RickAndMorty
//
//  Created by Luis Ezcurdia on 15/12/23.
//

import SwiftUI
import Combine

class CharactersListVM: ObservableObject {
    @Published var characters: [Character] = []
    @Published var isLoading = false
    private var currentPage: Int = 1
    private var hasMorePages = true
    private let client = RESTClient<PaginatedResponse<Character>>(client: Client.rickAndMorty)

    private var cancelableSet: Set<AnyCancellable> = []

    init() {
        load()
    }

    func loadMoreIfNeeded(currentCharacter character: Character?) {
        guard let character = character else {
            load()
            return
        }

        let thresholdIndex = characters.index(characters.endIndex, offsetBy: -5)
        let currentIndex = characters.firstIndex(where: { $0 == character })
        if currentIndex == thresholdIndex {
            load()
        }
    }

    func load() {
        guard !isLoading && hasMorePages else { return }

        isLoading = true
        client
            .showPublisher(path: "/api/character", page: currentPage)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { response in
                self.isLoading = false
                self.currentPage += 1
                if let _ = response?.info.next {
                    self.hasMorePages = true
                } else {
                    self.hasMorePages = false
                }
            })
            .map { self.characters + ($0?.results ?? []) }
            .catch({ _ in Just(self.characters) })
            .assign(to: \.characters, on: self)
            .store(in: &cancelableSet)
    }
}

struct CharactersListView: View {
    @ObservedObject var vm = CharactersListVM()

    var body: some View {
        NavigationView {
            List(vm.characters) { character in
                CharacterRow(character: character)
                    .onAppear {
                        vm.loadMoreIfNeeded(currentCharacter: character)
                    }
                if vm.isLoading {
                    ProgressView()
                }
            }
            .listStyle(.plain)
            .navigationTitle("Characters")
        }
    }
}

#Preview {
    CharactersListView()
}

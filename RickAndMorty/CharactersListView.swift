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

    private let client = RESTClient<PaginatedResponse<Character>>(client: Client.rickAndMorty)

    private var cancelableSet: Set<AnyCancellable> = []

    init() {
        client
            .showPublisher(path: "/api/character", page: 1)
            .receive(on: RunLoop.main)
            .sink { _ in
                print("Did complete loading")
            } receiveValue: { response in
                let results = response?.results ?? []
                self.characters.append(contentsOf: results)
            }
            .store(in: &cancelableSet)
    }
}

struct CharactersListView: View {
    let vm = CharactersListVM()

    var body: some View {
        NavigationView {
            List(vm.characters) { character in
                CharacterRow(character: character)
            }
            .listStyle(.plain)
            .navigationTitle("Characters")
        }
    }
}

#Preview {
    CharactersListView()
}

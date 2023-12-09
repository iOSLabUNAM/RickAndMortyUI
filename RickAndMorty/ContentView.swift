//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Diplomado on 01/12/23.
//

import SwiftUI

struct ContentView: View {
    let client = RESTClient<PaginatedResponse<Character>>(client: Client.rickAndMorty)
    @State var characters: [Character] = []
    var body: some View {
        NavigationView{
            List(characters) { character in
                CharacterRow(character: character)
            }
            .listStyle(.plain)
            .navigationTitle("Characters")
        }.task {
            let response = try? await client.show(path: "/api/character")
            self.characters = response?.results ?? []
        }
    }
}

#Preview {
    ContentView()
}

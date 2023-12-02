//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Diplomado on 01/12/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            List {
                CharacterRow(username: "John Doe")
                CharacterRow(username: "Jane Doe")
                CharacterRow(username: "Mary Jane Whatson")
            }
            .listStyle(.plain)
            .navigationTitle("Characters")
        }
    }
}

#Preview {
    ContentView()
}

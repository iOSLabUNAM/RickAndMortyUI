//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Diplomado on 01/12/23.
//

import SwiftUI

struct ContentView: View {
    var characters: [Character] = []
    var body: some View {
        NavigationView{
            List {
                Text("John Doe")
                Text("Jane Doe")
            }
            .listStyle(.plain)
            .navigationTitle("Characters")
        }.task {
            // let client = RESTClient<PaginatedResponse<Character>>(client: Client.rickAndMorty)
            print("Doing something async..")
        }
    }
}

#Preview {
    ContentView()
}

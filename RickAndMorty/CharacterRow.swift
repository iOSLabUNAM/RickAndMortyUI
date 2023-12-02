//
//  CharacterRow.swift
//  RickAndMorty
//
//  Created by Diplomado on 01/12/23.
//

import SwiftUI

struct CharacterRow: View {
    let character: Character
    var body: some View {
        HStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            Text(character.name)
                    .font(.system(size: 24, design: .rounded))
                Spacer()
            Text(character.species)
                .font(.system(size: 18, weight: .thin, design: .rounded))
        }.padding()
    }
}

#Preview {
    CharacterRow(character: Character(id: 1, name: "Rick Sanchez", species: "Human"))
}

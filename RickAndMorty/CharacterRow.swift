//
//  CharacterRow.swift
//  RickAndMorty
//
//  Created by Diplomado on 01/12/23.
//

import SwiftUI

struct CharacterRow: View {
    let username: String
    var body: some View {
        HStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                Text(username)
                    .font(.system(size: 24, design: .rounded))
                Spacer()
                Text("12 years")
                .font(.system(size: 18, weight: .thin, design: .rounded))
        }.padding()
    }
}

#Preview {
    CharacterRow(username: "joe doe")
}

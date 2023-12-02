//
//  PaginatedResponse.swift
//  RickAndMorty
//
//  Created by Diplomado on 02/12/23.
//

import Foundation

struct PaginatedResponse<T: Codable> {
    let info: PageInfo
    let results: [T]
}

struct PageInfo: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

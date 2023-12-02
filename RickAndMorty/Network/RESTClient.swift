//
//  RESTClient.swift
//  RickAndMorty
//
//  Created by Diplomado on 02/12/23.
//

import Foundation

struct RESTClient<T: Codable> {
    let client: Client
    let decoder: JSONDecoder = {
        var dec = JSONDecoder()
        dec.keyDecodingStrategy = .convertFromSnakeCase
        return dec
    }()
    
    init(client: Client) {
        self.client = client
    }
    
    typealias successHandler = ((T) -> Void)
    
    func show(_ path: String, success: @escaping successHandler) {
        client.get(path) { data in
            guard let data = data else { return }
            
            do {
                let json = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async { success(json) }
            } catch let err {
                #if DEBUG
                debugPrint(err)
                #endif
            }
        }
    }
}

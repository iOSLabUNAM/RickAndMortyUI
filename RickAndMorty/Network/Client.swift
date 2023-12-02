//
//  Client.swift
//  RickAndMorty
//
//  Created by Diplomado on 02/12/23.
//

import Foundation
import Combine

struct Client {
    let session = URLSession.shared
    let baseUrl: String
    private let contentType: String
    
    enum NetworkError: Error {
        case conection
        case invalidRequest
        case invalidResponse
        case client
        case server
    }
    
    init(_ baseUrl: String, contentType: String = "application/json") {
        self.baseUrl = baseUrl
        self.contentType = contentType
    }
    
    typealias requesHandler = ((Data?) -> Void)
    typealias errorHandler = ((NetworkError) -> Void)
    
    func get(_ path: String, success: requesHandler?, failure: errorHandler? = nil) {
        request(method: "GET", path: path, body: nil, success: success, failure: failure)
    }
    
    // Request via GCD using response handlers
    func request(method: String, path: String, body: Data?, success: requesHandler?, failure: errorHandler? = nil) {
        guard let request = buildRequest(method: method, path: path, body: body) else {
            failure?(NetworkError.invalidRequest)
            return
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let err = error {
                #if DEBUG
                debugPrint(err)
                #endif
                failure?(NetworkError.conection)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                failure?(NetworkError.invalidResponse)
                return
            }
            
            let status = StatusCode(rawValue: httpResponse.statusCode)
            #if DEBUG
            print("Status: \(httpResponse.statusCode)")
            debugPrint(httpResponse)
            #endif
            switch status {
            case .success:
                success?(data)
            case .clientError:
                failure?(.client)
            case .serverError:
                failure?(.server)
            default:
                failure?(.invalidResponse)
            }
        }
        task.resume()
    }
    
    // Request via async/await with Result type
    func request(method: String, path: String, body: Data?) async throws -> Result<Data?, NetworkError> {
        guard let request = buildRequest(method: method, path: path, body: body) else {
            return .failure(NetworkError.invalidRequest)
        }
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.invalidResponse)
        }
        
        let status = StatusCode(rawValue: httpResponse.statusCode)
        #if DEBUG
        print("Status: \(httpResponse.statusCode)")
        debugPrint(httpResponse)
        #endif
        switch status {
        case .success:
            return .success(data)
        case .clientError:
            return .failure(.client)
        case .serverError:
            return .failure(.server)
        default:
            return .failure(.invalidResponse)
        }
    }
    
    func requestPublisher(method: String, path: String, body: Data?) -> AnyPublisher<Data?, NetworkError> {
        guard let request = buildRequest(method: method, path: path, body: body) else {
            return Fail(error: NetworkError.invalidRequest).eraseToAnyPublisher()
        }
        return session
            .dataTaskPublisher(for: request)
            .tryMap { (data, response) -> Data? in
                let httpResponse = response as! HTTPURLResponse
                let status = StatusCode(rawValue: httpResponse.statusCode)
                #if DEBUG
                print("Status: \(httpResponse.statusCode)")
                debugPrint(httpResponse)
                #endif
                switch status {
                case .success: break
                case .clientError:
                    throw NetworkError.client
                case .serverError:
                    throw NetworkError.server
                default:
                    throw NetworkError.invalidResponse
                }
                return data
            }
            .mapError{ error -> NetworkError in
                switch error {
                case NetworkError.client:
                    return .client
                case NetworkError.server:
                    return .server
                default:
                    return NetworkError.invalidResponse
                }
            }
            .eraseToAnyPublisher()
        
    }
    
    private func buildRequest(method: String, path: String, body: Data?) -> URLRequest? {
        guard var urlComp = URLComponents(string: baseUrl) else { return nil }
        urlComp.path = path
        
        guard let url = urlComp.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        #if DEBUG
        debugPrint(request)
        #endif
        return request
    }
}

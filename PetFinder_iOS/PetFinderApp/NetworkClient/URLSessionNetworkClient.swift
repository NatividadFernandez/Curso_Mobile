//
//  URLSessionNetworkClient.swift
//  PetFinderApp
//
//  Created by user240565 on 20/11/23.
//

import Foundation

class URLSessionNetworkClient: NetworkClient {
    
    func call<T>(urlRequest: URLRequest) async throws -> T where T : Decodable {
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpUrlResponse = response as? HTTPURLResponse else {
            throw NetworkError.nilResponse
        }
        
        switch httpUrlResponse.statusCode {
        case 200...299:
            break
        default:
            throw NetworkError.response(httpUrlResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.encoding
        }
    }
    
    func getCall<T>(token: String, url: String, queryParams: [String : String]?) async throws -> T where T : Decodable {
        let urlComponents = NSURLComponents(string: url)
        
        if let queryParams {
            urlComponents?.queryItems = queryParams.map { URLQueryItem(name: $0, value: $1) }
        }
        
        guard let url = urlComponents?.url else {
            throw NetworkError.badUrl
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        return try await call(urlRequest: urlRequest)
    }
    
    func postCall<T>(url: String, body: Encodable?) async throws -> T where T : Decodable {
        guard let url = URL(string: url) else {
            throw NetworkError.badUrl
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpMethod = "POST"
        
        if let body {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        
        return try await call(urlRequest: urlRequest)
    }
}

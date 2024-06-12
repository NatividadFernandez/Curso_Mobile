//
//  NetworkClient.swift
//  PetFinderApp
//
//  Created by user240565 on 20/11/23.
//

import Foundation

protocol NetworkClient {
    func call<T: Decodable>(urlRequest: URLRequest) async throws -> T
    func getCall<T: Decodable>(token: String, url: String, queryParams: [String : String]?) async throws -> T
    func postCall<T: Decodable>(url: String, body: Encodable?) async throws -> T
}

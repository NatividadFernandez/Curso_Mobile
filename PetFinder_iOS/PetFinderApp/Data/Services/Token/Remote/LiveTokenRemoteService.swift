//
//  LiveTokenRemoteService.swift
//  PetFinderApp
//
//  Created by user240565 on 21/11/23.
//

import Foundation

struct LiveTokenRemoteService: TokenRemoteService {
    
    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func createAccessToken() async throws -> Token {
        let response: Token = try await networkClient.postCall(url: NetworkConstants.authNetworkUrl, body: NetworkConstants.bodyParams)
        return response
    }    
    
    
}

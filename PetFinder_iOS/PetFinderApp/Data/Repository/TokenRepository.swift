//
//  TokenRepository.swift
//  PetFinderApp
//
//  Created by user240565 on 21/11/23.
//

import Foundation

struct TokenRepository {
    
    let remoteService: TokenRemoteService
    let localService: TokenLocalService
    
    init(remoteService: TokenRemoteService, localService: TokenLocalService) {
        self.remoteService = remoteService
        self.localService = localService
    }
    
    func createAccessToken() async throws {
        let token = try await remoteService.createAccessToken()
        try await localService.saveAccessToken(token: token)
    }
    
    /*func saveAccessToken(token: Token) async throws {
        return try await localService.saveAccessToken(token: token)
    }
    
    func getAccessToken() async throws -> String {
        return try await localService.getAccessToken()
    } */
    
}

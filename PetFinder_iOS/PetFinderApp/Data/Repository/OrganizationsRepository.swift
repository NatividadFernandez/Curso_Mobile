//
//  OrganizationsRepository.swift
//  PetFinderApp
//
//  Created by user240565 on 24/11/23.
//

import Foundation

struct OrganizationsRepository {
    let remoteService: OrganizationsRemoteService
    let localTokenService: TokenLocalService
    
    init(remoteService: OrganizationsRemoteService, localTokenService: TokenLocalService) {
        self.remoteService = remoteService
        self.localTokenService = localTokenService
    }
    
    func getOrganizations() async throws -> [Organization] {
        let token = try await localTokenService.getAccessToken()
        return try await remoteService.getOrganizations(token: token)
    }
    
    func getOrganization(url: String) async throws -> Organization {
        let token = try await localTokenService.getAccessToken()
        return try await remoteService.getOrganization(token: token, url: url)
    }
}

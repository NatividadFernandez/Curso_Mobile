//
//  LiveOrganizationsRemoteService.swift
//  PetFinderApp
//
//  Created by user240565 on 24/11/23.
//

import Foundation

struct LiveOrganizationsRemoteService: OrganizationsRemoteService {
    
    let networkClient: NetworkClient
        
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getOrganizations(token: String) async throws -> [Organization] {
        let response: OrganizationsResponse = try await networkClient.getCall(token: token, url: NetworkConstants.organizationsNetworkUrl, queryParams: nil)
        return response.organizations
    }
    
    func getOrganization(token: String, url: String) async throws -> Organization {
        let response: OrganizationResponse = try await networkClient.getCall(token: token, url: "\(NetworkConstants.organizationsNetworkUrl)/\(url)", queryParams: nil)
        return response.organization
    }
}

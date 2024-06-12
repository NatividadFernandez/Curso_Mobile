//
//  LivePetsRemoteService.swift
//  PetFinderApp
//
//  Created by user240565 on 20/11/23.
//

import Foundation

struct LivePetsRemoteService: PetsRemoteService {

    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getPets(token: String, type: String, page: Int) async throws -> PetsResponse {
            return try await networkClient.getCall(token: token, url: NetworkConstants.petsNetworkUrl, queryParams: ["type": type, "page": page.description])
    }
    
    func getPet(token: String, petId: Int) async throws -> Pet {
        let response: PetResponse = try await networkClient.getCall(token: token, url: "\(NetworkConstants.petsNetworkUrl)/\(petId)", queryParams: nil)
        return response.pet
    }
    
    func getPetTypes(token: String) async throws -> [TypeElement] {
        let response: PetTypeResponse = try await networkClient.getCall(token: token, url: NetworkConstants.petTypeNetworkUrl, queryParams: nil)
        
        let typeDefaults = TypeElement(name: "all")
        let newResponse = [typeDefaults] + response.types
        
        return newResponse
    }
    
    
}



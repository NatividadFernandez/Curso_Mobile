//
//  PetsRepository.swift
//  PetFinderApp
//
//  Created by user240565 on 20/11/23.
//

import Foundation

struct PetsRepository {
    let remoteService: PetsRemoteService
    let localService: PetsLocalService
    let localTokenService: TokenLocalService
    
    
    init(remoteService: PetsRemoteService, localService: PetsLocalService, localTokenService: TokenLocalService) {
        self.remoteService = remoteService
        self.localService = localService
        self.localTokenService = localTokenService
    }
    
    func getPets(type: String, page: Int) async throws -> PetsResponse {
        let token = try await localTokenService.getAccessToken()
        return try await remoteService.getPets(token: token, type: type, page: page)
    }
    
    func getPet(petId: Int) async throws -> Pet {
        let token = try await localTokenService.getAccessToken()
        return try await remoteService.getPet(token: token, petId: petId)
    }
    
    func getFavoritePets() async throws -> [Pet] {
        return try await localService.getFavoritePets()
    }
    
    func addFavoritePet(pet: Pet) async throws {
        try await localService.addFavoritePet(pet: pet)
    }
    
    func removeFavoritePet(pet: Pet) async throws {
        try await localService.removeFavoritePet(pet: pet)
    }
    
    func isFavoritePet(pet: Pet) async throws -> Bool {
        return try await localService.isFavoritePet(pet: pet)
    }
    
    func getPetTypes() async throws -> [TypeElement] {
        let token = try await localTokenService.getAccessToken()
        return try await remoteService.getPetTypes(token: token)
    }
    
    
}

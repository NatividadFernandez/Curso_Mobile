//
//  UserDefaultsPetService.swift
//  PetFinderApp
//
//  Created by user240565 on 29/11/23.
//

import Foundation

struct UserDefaultsPetService: PetsLocalService {
        
    private let favoritePetsKey = "favorite_pets"
    
    func getFavoritePets() async throws -> [Pet] {
        guard let data = UserDefaults.standard.data(forKey: favoritePetsKey) else {
            return []
        }
        return try JSONDecoder().decode([Pet].self, from: data)
    }
    
    func addFavoritePet(pet: Pet) async throws {
        var pets = try await getFavoritePets()
        pets.append(pet)
        try await saveFavoritePets(pets: pets)
    }
    
    func removeFavoritePet(pet: Pet) async throws {
        var pets = try await getFavoritePets()
        pets.removeAll { p in
            p.id == pet.id
        }
        try await saveFavoritePets(pets: pets)
    }
    
    func isFavoritePet(pet: Pet) async throws -> Bool {
        let pets = try await getFavoritePets()
        return pets.contains { p in
            p.id == pet.id
        }
    }
    
    private func saveFavoritePets(pets: [Pet]) async throws {
        let data = try JSONEncoder().encode(pets)
        UserDefaults.standard.set(data, forKey: favoritePetsKey)
    }
    
}

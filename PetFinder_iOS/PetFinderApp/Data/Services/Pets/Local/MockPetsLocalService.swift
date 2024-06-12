//
//  MockPetsLocalService.swift
//  PetFinderApp
//
//  Created by user240565 on 29/11/23.
//

import Foundation

struct MockPetsLocalService: PetsLocalService {
    
    private var pets = [Pet]()
    
    func getFavoritePets() async throws -> [Pet] {
        return pets
    }
    
    func addFavoritePet(pet: Pet) async throws {
        print("Added to favorites")
    }
    
    func removeFavoritePet(pet: Pet) async throws {
        print("Removed from favorites")
    }
    
    func isFavoritePet(pet: Pet) async throws -> Bool {
        return true
    }    
    
    
}

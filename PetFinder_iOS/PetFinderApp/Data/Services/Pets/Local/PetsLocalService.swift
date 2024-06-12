//
//  PetsLocalService.swift
//  PetFinderApp
//
//  Created by user240565 on 29/11/23.
//

import Foundation

protocol PetsLocalService {
    
    func getFavoritePets() async throws -> [Pet]
    
    func addFavoritePet(pet: Pet) async throws
    
    func removeFavoritePet(pet: Pet) async throws
    
    func isFavoritePet(pet: Pet) async throws -> Bool
}

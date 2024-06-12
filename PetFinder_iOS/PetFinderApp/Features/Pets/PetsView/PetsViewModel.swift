//
//  PetsViewModel.swift
//  PetFinderApp
//
//  Created by user240565 on 20/11/23.
//

import Foundation

class PetsViewModel: ObservableObject {
    
    private let petsRepository: PetsRepository
    
    @Published var isLoading = false
    @Published var isLoadingType = false
    @Published var pets: [Pet] = []
    @Published var favoritePets: [Pet] = []
    @Published var pet: Pet?
    @Published var error: Error?
    @Published var errorType: Error?
    @Published var isFavorite = false
    @Published var petTypes: [TypeElement] = []
    
    private var currentPetsPage = 0
    private var maxPetsPages: Int?
    
    init(petsRepository: PetsRepository) {
        self.petsRepository = petsRepository
    }
    
    @MainActor
    func getPets(type: String, enablePaging: Bool = false) async {
        if let maxPages = maxPetsPages, maxPages == currentPetsPage {
            return
        }
        
        if enablePaging {
            currentPetsPage += 1
        } else {
            currentPetsPage = 1
            pets = []
        }
        
        error = nil
        isLoading = true
        do {
            let petsResponse = try await petsRepository.getPets(type: type, page: currentPetsPage)
            
            maxPetsPages = petsResponse.pagination.totalPages
            pets.append(contentsOf: petsResponse.pets)
            
        } catch (let error) {
            self.error = error
        }
        
        isLoading = false
        
    }
    
    @MainActor
    func getPet(petId: Int) async {
        error = nil
        isLoading = true
        
        do {
            pet = try await petsRepository.getPet(petId: petId)
        } catch (let error) {
            self.error = error
        }
        
        isLoading = false
    }
    
    @MainActor
    func getPetTypes() async {
        errorType = nil
        isLoadingType = true
        
        do {
            petTypes = try await petsRepository.getPetTypes()
        } catch (let error) {
            self.error = error
        }
        
        isLoadingType = false
    }
    
    @MainActor
    func getFavoritePets() async {
        error = nil
        isLoading = true
        
        do {
            favoritePets = try await petsRepository.getFavoritePets()
        } catch (let error) {
            self.error = error
        }
        
        isLoading = false
    }
    
    @MainActor
    func addFavoritePet(pet: Pet) async {
        error = nil
        
        do {
            try await petsRepository.addFavoritePet(pet: pet)
            isFavorite = true
        } catch (let error) {
            self.error = error
        }
    }
    
    @MainActor
    func removeFavoriteCharacter(pet: Pet) async {
        error = nil
        
        do {
            try await petsRepository.removeFavoritePet(pet: pet)
            isFavorite = false
        } catch (let error) {
            self.error = error
        }
    }
    
    @MainActor
    func isFavoritePet(pet: Pet) async {
        error = nil
        
        do {
            isFavorite = try await petsRepository.isFavoritePet(pet: pet)
        } catch (let error) {
            self.error = error
        }
    }
}

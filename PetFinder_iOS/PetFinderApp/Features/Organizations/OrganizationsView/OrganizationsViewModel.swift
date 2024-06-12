//
//  OrganizationsViewModel.swift
//  PetFinderApp
//
//  Created by user240565 on 24/11/23.
//

import Foundation

class OrganizationsViewModel: ObservableObject {
    
    private let organizationsRepository: OrganizationsRepository
    
    @Published var isLoading = false
    @Published var organizations: [Organization] = []
    @Published var organization: Organization? 
    @Published var error: Error?
    
    init(organizationsRepository: OrganizationsRepository) {
        self.organizationsRepository = organizationsRepository
    }
    
    @MainActor
    func getOrganizations() async {
        error = nil
        isLoading = true
        
        do {
            organizations = try await organizationsRepository.getOrganizations()
        } catch (let error) {
            self.error = error
        }
        
        isLoading = false
    }
    
    @MainActor
    func getOrganization(url: String) async {
        error = nil
        isLoading = true
        
        do {
            organization = try await organizationsRepository.getOrganization(url: url)
        } catch (let error) {
            self.error = error
        }
        
        isLoading = false
    }
}

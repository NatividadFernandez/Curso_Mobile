//
//  ContentViewModel.swift
//  PetFinderApp
//
//  Created by user240565 on 21/11/23.
//

import Foundation

class SplashScreenViewModel: ObservableObject {
    
    private let tokenRepository: TokenRepository
    
    @Published var isLoading = false
    @Published var error: Error?
    
    init(tokenRepository: TokenRepository) {
        self.tokenRepository = tokenRepository
    }
    
    @MainActor
    func createAccessToken() async {
        error = nil
        isLoading = true
        
        do {
            try await tokenRepository.createAccessToken()
        } catch (let error) {
            self.error = error
        }
        
        isLoading = false
    }
}

//
//  Coordinator.swift
//  PetFinderApp
//
//  Created by user240565 on 20/11/23.
//

import Foundation

class Coordinator: ObservableObject {
    
    private let tokenRepository: TokenRepository
    private let petsRepository: PetsRepository
    private let organizationsRepositorty: OrganizationsRepository
    
    init(mock: Bool = false) {
        
        let networkClient = URLSessionNetworkClient()
        
        self.tokenRepository = TokenRepository(remoteService: LiveTokenRemoteService(networkClient: networkClient), localService: UserDefaultsTokenLocalService())
        
        let petsRemoteService: PetsRemoteService = mock ? MockPetsRemoteService() : LivePetsRemoteService(networkClient: networkClient)
        let petsLocalervice: PetsLocalService = mock ? MockPetsLocalService() : UserDefaultsPetService()
        
        self.petsRepository = PetsRepository(remoteService: petsRemoteService, localService: petsLocalervice, localTokenService: UserDefaultsTokenLocalService())
        
        let organizationsRemoteService: OrganizationsRemoteService = mock ? MockOrganizationsRemoteService() : LiveOrganizationsRemoteService(networkClient: networkClient)
        
        self.organizationsRepositorty = OrganizationsRepository(remoteService: organizationsRemoteService, localTokenService: UserDefaultsTokenLocalService())
        
    }
    
    // MARK: Pets View
    
    func makePetsView() -> PetsView {
        return PetsView(viewModel: makePetsViewModel())
    }
    
    func makePetsViewModel() -> PetsViewModel {
        return .init(petsRepository: petsRepository)
    }
    
    func makePetDetailView(petId: Int, popHandler: (() -> Void)? = nil) -> PetDetailView {
        .init(viewModel: makePetsViewModel(), petId: petId, popHandler: popHandler)
    }
    
    func makeFavoritePet() -> PetsFavoriteView {
        .init(viewModel: makePetsViewModel())
    }
    
    // MARK: Organizations View
    
    func makeOrganizationsView() -> OrganizationsView {
        return OrganizationsView(viewModel: makeOrganizationsViewModel())
    }
    
    func makeOrganizationsViewModel() -> OrganizationsViewModel {
        return .init(organizationsRepository: organizationsRepositorty)
    }
    
    func makeOrganizationDetailView(organizationId: String) -> OrganizationDetailView {
        .init(viewModel: makeOrganizationsViewModel(), organizationId: organizationId)
    }
    
    // MARK: Splash Screen View
    
    func makeSplashScreenView() -> SplashScreenView {
        return SplashScreenView(viewModel: makeSplashScreenViewModel())
    }
    
    func makeSplashScreenViewModel() -> SplashScreenViewModel {
        return .init(tokenRepository: tokenRepository)
    }
    
}

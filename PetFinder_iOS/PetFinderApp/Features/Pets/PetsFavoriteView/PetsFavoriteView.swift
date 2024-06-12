//
//  PetsFavoriteView.swift
//  PetFinderApp
//
//  Created by user240565 on 29/11/23.
//

import SwiftUI

struct PetsFavoriteView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    @StateObject private var viewModel: PetsViewModel
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 170))
    ]
    
    init(viewModel: PetsViewModel) {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.purpleLight]
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack  {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if !viewModel.favoritePets.isEmpty {
                    ScrollView {
                        LazyVGrid(columns: adaptiveColumns, spacing: 20) {
                            ForEach(viewModel.favoritePets , id: \.id) { pet in
                                makeGoToDetailNavigationLink(for: pet)
                            }
                        }.padding(.horizontal,20)
                    }                    
                } else {
                    Text("You do not have any favorite items yet!")
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.inline)
            .foregroundStyle(.purpleLight)
            
        }.task {
            await viewModel.getFavoritePets()
        }
    }
    
    func makeGoToDetailNavigationLink(for pet: Pet) -> some View {
        NavigationLink {
            coordinator.makePetDetailView(petId: pet.id, popHandler: {
                Task {
                    await viewModel.getFavoritePets()
                }
            })
        } label: {
            PetRowView(pet: pet)
        }
    }
}

#Preview {
    let coordinator = Coordinator(mock: true)
    return coordinator.makeFavoritePet().environmentObject(coordinator)
}

//
//  PetDetailView.swift
//  PetFinderApp
//
//  Created by user240565 on 20/11/23.
//

import SwiftUI
import SimpleToast

struct PetDetailView: View {
    
    
    @EnvironmentObject var coordinator: Coordinator
    @StateObject private var viewModel: PetsViewModel
    let petId: Int
    let popHandler: (() -> Void)?
    
    @State var showToast: Bool = false
    
    private let toastOptions = SimpleToastOptions(
        hideAfter: 3
    )
    
    init(viewModel: PetsViewModel, petId: Int, popHandler: (() -> Void)? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.petId = petId
        self.popHandler = popHandler
    }
    
    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                ProgressView()
            } else if let pet = viewModel.pet {
                VStack(spacing: 0) {
                    contentImage(pet: pet)
                    VStack(alignment: .leading) {
                        HStack {
                            Text(pet.name).font(.system(size: 22)).fontWeight(.bold).foregroundStyle(.purpleDark)
                            Text("-").font(.system(size: 22)).fontWeight(.bold).foregroundStyle(.dark)
                            Text(pet.breeds?.primary ?? "").font(.system(size: 18)).foregroundStyle(.dark)
                        }.padding(.vertical, 10)
                        
                        Label {
                            Text(pet.contact?.address?.city ?? "No data")
                        } icon: {
                            Image(systemName: "location")
                                .foregroundColor(.purpleLight)
                        }.font(.system(size: 15))
                        
                        characteristicScrollView(pet: pet)
                        
                        Section {
                            VStack {
                                ScrollView {
                                    Text(pet.description ?? "There is no information")
                                        .font(.system(size: 15))
                                        .fontWeight(.regular)
                                        .foregroundStyle(.dark)
                                }
                            }
                        } header: {
                            Text("Description")
                                .foregroundStyle(.purpleDark)
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .padding(.vertical,5)
                            
                        }
                        
                        contentHorizontal(pet: pet)
                        
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.gray.opacity(0.3))
                    .clipShape(.rect(topLeadingRadius:30,topTrailingRadius: 30))
                    
                }.simpleToast(isPresented: $showToast, options: toastOptions) {
                    Label(viewModel.isFavorite ? "Added to the favorites list" : "Delete to the favorite list", systemImage:viewModel.isFavorite ? "checkmark" : "trash.fill")
                        .padding()
                        .background(viewModel.isFavorite ? Color.green.opacity(0.8) : Color.red.opacity(0.8) )
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                        .padding(.top)
                }
                .toolbar {
                    makeFavorite(pet: pet)
                }.task {
                    await viewModel.isFavoritePet(pet: pet)
                }
            }
        }.task {
            await viewModel.getPet(petId: petId)
        }
    }
    
    private func makeFavorite(pet: Pet) -> some View {
        Button(action: {
            Task {
                await toggleFavoritePet(pet: pet)
                popHandler?()
                
            }
            showToast.toggle()
        }, label: {
            Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundStyle(.purpleLight)
        })
    }
    
    private func toggleFavoritePet(pet: Pet) async {
        if viewModel.isFavorite {
            await viewModel.removeFavoriteCharacter(pet: pet)
        } else {
            await viewModel.addFavoritePet(pet: pet)
        }
    }
    
    private func characteristicScrollView(pet: Pet) -> some View {
        HStack(alignment: .center) {
            Spacer()
            ForEach(pet.characteristics.filter { $0.title.lowercased() != "unknown"}, id: \.id) { info in
                Color.purpleLight
                    .frame(width: 90, height: 90)
                    .cornerRadius(30)
                    .overlay(
                        VStack {
                            Text(info.label.capitalized).fontWeight(.bold)
                                .minimumScaleFactor(0.9)
                                .lineLimit(1)
                                .padding(.horizontal, 5).padding(.vertical, 3)
                            Text(capitalizeFirstLetter(info.title.lowercased())).fontWeight(.light)
                        }
                        .foregroundColor(.white)
                    )
            }
            Spacer()
        }
        .padding(.vertical,5)
    }
    
    private func contentImage(pet: Pet) -> some View {
        VStack(alignment: .center){
            AsyncImage(url: URL(string: pet.photos?.first?.full ?? "")) { imagePhase in
                switch imagePhase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 190, height: 180)
                        .cornerRadius(10)
                        .clipped()
                default:
                    Image("pawPlaceholder")
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 190, height: 180)
                        .cornerRadius(10)
                        .clipped()
                }
            }
            .padding(.horizontal,2)
            .padding(.top,10)
            
        }.padding()
    }
    
    private func contentHorizontal(pet: Pet) -> some View {
        HStack() {
            VStack(alignment: .leading) {
                Label {
                    Text(pet.contact?.phone ?? "No data")
                } icon: {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.purpleLight)
                }.font(.system(size: 15)).padding(.bottom,5)
                
                Label {
                    Text(pet.contact?.email ?? "No data")
                } icon: {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.purpleLight)
                }.font(.system(size: 15))
            }
            Spacer()
            NavigationLink {
                coordinator.makeOrganizationDetailView(organizationId: pet.organizationID)
            } label: {
                Image(systemName: "building.2.fill" )
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .padding(20)
                    .background(.purpleLight)
                    .cornerRadius(20)
            }
            
        }.padding(.top,5).padding(.bottom,2)
        
    }
    
    private func capitalizeFirstLetter(_ text: String) -> String {
        guard let first = text.first else {
            return text
        }
        return String(first).capitalized + String(text.dropFirst())
    }
    
}

#Preview {
    let coordinator = Coordinator(mock: true)
    return coordinator.makePetDetailView(petId: 1).environmentObject(coordinator)
}

//
//  PetsView.swift
//  PetFinderApp
//
//  Created by user240565 on 20/11/23.
//

import SwiftUI

struct PetsView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    @StateObject private var viewModel: PetsViewModel
    @State private var selectedPetType: String = "all"
    @State private var verticalScrollProxy: ScrollViewProxy? = nil
    @State private var searchTerm: String = ""
    @Namespace var topID
    
    @State var scrollViewOffset: CGFloat = 0
    @State var startOffset: CGFloat = 0
    
    var filteredPets: [Pet] { // Algunas veces aparece un error?
        guard !searchTerm.isEmpty else { return viewModel.pets }
        return viewModel.pets.filter { $0.name.localizedCaseInsensitiveContains(searchTerm) || $0.age.localizedCaseInsensitiveContains(searchTerm) }
    }
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 170))
    ]
    
    init(viewModel: PetsViewModel) {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.purpleLight]
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Section {
                    HStack {
                        if viewModel.isLoadingType {
                            Spacer()
                            ProgressView()
                            Spacer()
                            
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(viewModel.petTypes, id: \.name) { type in
                                        Text(capitalizeFirstLetter(type.name))
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(selectedPetType == type.name ? .purpleLight : Color.gray)
                                            .foregroundColor(.white)
                                            .cornerRadius(15)
                                            .onTapGesture {
                                                selectedPetType = type.name
                                                Task {
                                                    await viewModel.getPets(type: type.name.lowercased() == viewModel.petTypes.first?.name ? "" : selectedPetType)
                                                }
                                                
                                                if let verticalScrollProxy = verticalScrollProxy {
                                                    withAnimation {
                                                        verticalScrollProxy.scrollTo(topID, anchor: .top)
                                                    }
                                                }
                                                
                                            }
                                    }
                                    
                                }
                            }
                        }
                        
                    }.task {
                        await viewModel.getPetTypes()
                    }
                    
                } header: {
                    Text("Types")
                }
                
                Section {
                    VStack {
                        ScrollViewReader { proxyReader in
                            ScrollView(.vertical, showsIndicators: false, content:  {
                                VStack(spacing: 25) {                                    
                                    LazyVGrid(columns: adaptiveColumns, spacing: 20) {
                                        ForEach(filteredPets) { pet in
                                            makeGoToDetailNavigationLink(for: pet)
                                                .task {
                                                    if viewModel.pets.last?.id == pet.id {
                                                        await viewModel.getPets(type: selectedPetType == "all" ? "" : selectedPetType, enablePaging: true)
                                                    }
                                                    
                                                }
                                        }
                                    }
                                }
                                .id(topID)
                                .overlay(
                                    GeometryReader { proxy -> Color in
                                        
                                        DispatchQueue.main.async {
                                            if startOffset == 0 {
                                                self.startOffset = proxy.frame(in: .global).minY
                                            }
                                            
                                            let offset = proxy.frame(in: .global).minY
                                            self.scrollViewOffset = offset - startOffset
                                        }
                                        
                                        return Color.clear
                                    }
                                    
                                )
                            })
                            .onAppear {
                                if verticalScrollProxy == nil {
                                    verticalScrollProxy = proxyReader
                                }
                            }
                            .overlay(
                                Button(action: {
                                    withAnimation(.spring()) {
                                        proxyReader.scrollTo(topID, anchor: .top)
                                    }
                                    
                                }, label: {
                                    Image(systemName: "arrow.up")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundStyle(.white)
                                        .padding()
                                        .background(.purpleLight)
                                        .clipShape(Circle())
                                        .shadow(color: Color.black.opacity(0.09), radius: 5, x: 5, y: 5)
                                })
                                .padding(.trailing)
                                .padding(.bottom, 5)
                                .opacity(-scrollViewOffset > 450 ? 1 : 0)
                                .animation(Animation.easeInOut(duration: 1.0), value: UUID())
                                , alignment: .bottomTrailing
                                
                            )
                            
                        }
                        
                    }.searchable(text: $searchTerm, prompt: "Search by name or age ...")
                    
                    if viewModel.isLoading {
                        HStack{
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }
                    
                } header: {
                    Text("Pets").padding(.top,2)
                }
            }
            .background(.white)
            .navigationTitle("Pet Adopt")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal,20)
        }
        .task {
            selectedPetType = "all"
            await viewModel.getPets(type: "")
            if let verticalScrollProxy = verticalScrollProxy {
                withAnimation {
                    verticalScrollProxy.scrollTo(topID, anchor: .top)
                }
            }
        }
    }
    
    func makeGoToDetailNavigationLink(for pet: Pet) -> some View {
        NavigationLink {
            coordinator.makePetDetailView(petId: pet.id)
        } label: {
            PetRowView(pet: pet)
        }
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
    return coordinator.makePetsView().environmentObject(coordinator)
}


//
//  OrganizationsView.swift
//  PetFinderApp
//
//  Created by user240565 on 24/11/23.
//

import SwiftUI

struct OrganizationsView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    @StateObject private var viewModel: OrganizationsViewModel
    @State private var searchTerm: String = ""
    
    var filteredOrganizations: [Organization] {
        guard !searchTerm.isEmpty else { return viewModel.organizations }
        return viewModel.organizations.filter { $0.name.localizedCaseInsensitiveContains(searchTerm) }
    }
    
    init(viewModel: OrganizationsViewModel) {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.purpleLight]
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                ScrollView() {
                    VStack(alignment: .leading) {
                        ForEach(filteredOrganizations, id: \.id) { organization in
                            NavigationLink {
                                coordinator.makeOrganizationDetailView(organizationId: organization.id)
                            } label: {
                                OrganizationRowView(organization: organization)
                            }
                        }
                    }
                    
                }
                .navigationTitle("Organizations")
                .navigationBarTitleDisplayMode(.inline).scrollContentBackground(.hidden)
                .searchable(text: $searchTerm, prompt: "Search by name ...")
            }
            
        }
        .task {
            await viewModel.getOrganizations()
        }
    }
}

#Preview {
    let coordinator = Coordinator(mock: true)
    return coordinator.makeOrganizationsView().environmentObject(coordinator)
}


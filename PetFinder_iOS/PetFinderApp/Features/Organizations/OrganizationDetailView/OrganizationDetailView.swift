//
//  OrganizationDetailView.swift
//  PetFinderApp
//
//  Created by user240565 on 24/11/23.
//

import SwiftUI

struct OrganizationDetailView: View {
    
    @StateObject var viewModel: OrganizationsViewModel
    let organizationId: String
    
    init(viewModel: OrganizationsViewModel, organizationId: String) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.organizationId = organizationId
    }
    
    var body: some View {
        
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if let organization = viewModel.organization {
                VStack(spacing: 0) {
                    contentImage(organization: organization)
                    VStack(alignment: .leading) {
                        HStack {
                            Text(organization.name).font(.system(size: 22)).fontWeight(.bold).foregroundStyle(.purpleDark)
                        }.padding(.vertical, 10)
                        
                        Label {
                            Text(organization.address?.city ?? "No data")
                        } icon: {
                            Image(systemName: "location")
                                .foregroundColor(.purpleLight)
                        }.font(.system(size: 15))
                        
                        hoursScrollView(organization: organization)
                        
                        Section {
                            VStack {
                                ScrollView {
                                    Text(organization.missionStatement ?? "There is no information")
                                        .font(.system(size: 15))
                                        .fontWeight(.regular)
                                        .foregroundStyle(.dark)
                                }
                            }
                        } header: {
                            Text("Task")
                                .foregroundStyle(.purpleDark)
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .padding(.vertical,5)
                            
                        }
                        
                        contentInformation(organization: organization)
                        
                    }.padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.gray.opacity(0.3))
                        .clipShape(.rect(topLeadingRadius:30,topTrailingRadius: 30))
                }
            }
        }.task {
            await viewModel.getOrganization(url: organizationId)
        }
    }
    
    private func contentImage(organization: Organization) -> some View {
        VStack(alignment: .center){
            AsyncImage(url: URL(string: organization.photos?.first?.full ?? "")) { imagePhase in
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
                    Image("orgPlaceholder")
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 190, height: 180)
                        .cornerRadius(10)
                        .clipped()
                }
            }
            .padding(.horizontal,2)
            
        }.padding()
    }
    
    private func hoursScrollView(organization: Organization) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center) {
                ForEach(organization.hoursList.filter { $0.title.lowercased() != "unknown"}, id: \.id) { info in
                    Color.purpleLight
                        .frame(width: 130, height: 90)
                        .cornerRadius(30)
                        .overlay(
                            VStack {
                                Text(info.label.capitalized).fontWeight(.bold)
                                    .minimumScaleFactor(0.9)
                                    .lineLimit(1)
                                    .padding(.horizontal, 5).padding(.vertical, 3)
                                Text(info.title.lowercased() != "" ? capitalizeFirstLetter(info.title.lowercased()) : "--" ).fontWeight(.light)
                            }
                                .foregroundColor(.white)
                        )
                }
            }
            .padding(.vertical,5)
        }
    }
    
    private func contentInformation(organization: Organization) -> some View {
        HStack() {
            VStack(alignment: .leading) {
                Label {
                    Text(organization.phone ?? "No data")
                } icon: {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.purpleLight)
                }.font(.system(size: 15)).padding(.bottom,5)
                
                Label {
                    Text(organization.email ?? "No data")
                } icon: {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.purpleLight)
                }.font(.system(size: 15))
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
    return coordinator.makeOrganizationDetailView(organizationId: "NJ333").environmentObject(coordinator)
}

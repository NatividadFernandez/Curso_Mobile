//
//  OrganizationRowView.swift
//  PetFinderApp
//
//  Created by user240565 on 5/1/24.
//

import SwiftUI

struct OrganizationRowView: View {
    
    let organization: Organization
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: organization.photos?.first?.full ?? "")) { imagePhase in
                switch imagePhase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .cornerRadius(10)
                        .clipped()
                default:
                    Image("orgPlaceholder")
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .cornerRadius(10)
                        .clipped()
                }
            }
            .padding(.horizontal, 5)
            .padding(.vertical,5)
            
            VStack(alignment: .leading) {
                Text(organization.name)
                    .font(.headline).foregroundStyle(.purpleDark)
                    .lineLimit(1)
                    .padding(.bottom,2)
                
                Label {
                    Text(organization.address?.city ?? "No data")
                } icon: {
                    Image(systemName: "location")
                        .foregroundColor(.dark)
                }.font(.caption)
                    .padding(.bottom,2)
                
                Label {
                    Text(organization.email ?? "No data")
                        .lineLimit(1)
                } icon: {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.dark)
                }.font(.caption)
                    .padding(.bottom,2)
                
                
            }.padding(.horizontal, 2)
                .padding(.vertical,5)
            
            Spacer()
        }        
        .background(Color(red: 0.88, green: 0.84, blue: 0.96))
        .foregroundStyle(.dark)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.09), radius: 5, x: 5, y: 5)
        .padding(.horizontal)
        .padding(.vertical, 2)
    }
}

#Preview {
    OrganizationRowView(organization: .example)
}

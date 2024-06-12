//
//  PetRowView.swift
//  PetFinderApp
//
//  Created by user240565 on 14/12/23.
//

import SwiftUI

struct PetRowView: View {
    
    let pet: Pet
    
    var body: some View {
        VStack(alignment:.center) {
            AsyncImage(url: URL(string: pet.photos?.first?.full ?? "")) { imagePhase in
                switch imagePhase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 130, height: 120)
                        .cornerRadius(10)
                        .clipped()
                default:
                    Image("pawPlaceholder")
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 130, height: 120)
                        .cornerRadius(10)
                        .clipped()
                }
            }
            .padding(.horizontal,2)
            .padding(.top,10)
            
            
            HStack() {
                Spacer()
                VStack(alignment: .leading) {
                    Text(pet.name)
                        .lineLimit(1)
                        .font(.headline)
                        .foregroundStyle(.purpleDark)
                    HStack{
                        Label(pet.age, systemImage: "birthday.cake")
                            .font(.caption)
                        Spacer()
                        Label(pet.gender, systemImage: selectGender(gender: pet.gender))
                            .font(.caption)
                        Spacer()
                    }
                    
                    Label(pet.contact?.address?.city ?? "No data", systemImage: "location")
                        .font(.caption)
                    
                }.padding(.horizontal,10)
                    .padding(.bottom, 10)
                
            }.foregroundStyle(.dark)
        }
        .background(Color(red: 0.88, green: 0.84, blue: 0.96))
        .cornerRadius(10)
        .shadow(radius: 1)
    }
    
    private func selectGender(gender: String) -> String {
        return gender.lowercased() == "female" ? "leaf" : "flame"
    }
}

#Preview {
    PetRowView(pet: .example)
}

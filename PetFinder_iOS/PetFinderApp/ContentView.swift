//
//  ContentView.swift
//  PetFinderApp
//
//  Created by user240565 on 20/11/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        TabView {
            coordinator.makePetsView()
                .tabItem {
                    Label("Pets", systemImage: "pawprint.fill")
                }
            coordinator.makeOrganizationsView()
                .tabItem {
                    Label("Organizations", systemImage: "building.2.fill")
                }
            coordinator.makeFavoritePet()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
        }.tint(.purpleLight)
    }
}

#Preview {    
    let coordinator = Coordinator(mock: true)
    return ContentView().environmentObject(coordinator)
}

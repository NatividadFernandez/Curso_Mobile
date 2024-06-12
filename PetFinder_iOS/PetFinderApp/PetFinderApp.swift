//
//  PetFinderAppApp.swift
//  PetFinderApp
//
//  Created by user240565 on 20/11/23.
//

import SwiftUI

@main
struct PetFinderApp: App {
    
    let coordinator = Coordinator()
    var body: some Scene {
        WindowGroup {
            coordinator.makeSplashScreenView().environmentObject(coordinator)
        }
    }
}

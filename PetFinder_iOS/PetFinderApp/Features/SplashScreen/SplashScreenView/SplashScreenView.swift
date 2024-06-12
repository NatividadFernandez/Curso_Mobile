//
//  SplashScreenView.swift
//  PetFinderApp
//
//  Created by user240565 on 22/11/23.
//

import SwiftUI

struct SplashScreenView: View {
    
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var viewModel: SplashScreenViewModel
    
    init(viewModel: SplashScreenViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    @State private var isActive = false
    @State private var size = 0.2
    @State private var opacity = 0.5    
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            VStack {
                
                VStack {
                    LottieView(loopMode: .loop, animationName: "animationPet")
                    Text("Pet Adopt")
                        .font(Font.custom("Monserrat", size: 80))
                        .foregroundColor(.purpleLight.opacity(0.80))
                    
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.4
                        self.opacity = 1.0
                    }
                }
                
            }
            .onAppear {
                Task {
                    await viewModel.createAccessToken()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    let coordinator = Coordinator(mock: true)
    return coordinator.makeSplashScreenView().environmentObject(coordinator)
}

//
//  MainView.swift
//  lab3
//
//  Created by dumonten on 15/3/24.
//

import SwiftUI
import Firebase
import Combine

struct MainView: View {
    @State private var isAuthenticated = false
    @StateObject var authHandler = FirebaseAuthHandler()
    @StateObject var navigationManager = NavigationManager()

    var body: some View {
        Group {
            if isAuthenticated {
                ContentView()
                    .environmentObject(navigationManager)
                    .onChange(of: navigationManager.navigateToLogin) { newValue in
                        if newValue {
                            isAuthenticated = false
                        }
                    }
            } else {
                LoginView(isAuthenticated: $isAuthenticated)
                    .environmentObject(navigationManager) // Attach NavigationManager here
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                isAuthenticated = authHandler.isAuthenticated()
            }
        }
    }
}

//
//  ContentView.swift
//  lab3
//
//  Created by dumonten on 15/3/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            UserMainView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            FavoritesView()
                .tabItem {
                    Image(systemName: "star")
                    Text("Favorites")
                }
            UserProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
        .accentColor(Color(.systemPink))
    }
}

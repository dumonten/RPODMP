//
//  CityView.swift
//  lab3
//
//  Created by dumonten on 15/3/24.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseAuth

struct CityView: View {
    let cityEntity: CityEntity
    @State private var isAdding = false
    @State private var isInFavorites = false

    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Country: \(cityEntity.country )")
                    Text("Year of foundation: \(cityEntity.yearOfFoundation)")
                    Text("Description: \(cityEntity.description )")
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 5)
                .background(Color.board)
                .frame(maxHeight: .none)
                
                ImagesHolder(images: cityEntity.imageUrls)
                
                Button(action: {
                    _addToFavorites()
                }) {
                    HStack {
                        if isAdding {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text(isInFavorites ? "Remove from favorites" : "Add to favorites")
                                .foregroundColor(Color.buttonText)
                        }
                    }
                    .padding(.horizontal, 50)
                    .frame(height: 25)
                    .background(Color.button)
                    .cornerRadius(10)
                }
                .padding(.bottom, 20)
            }
            .frame(maxHeight: .none)
            .navigationBarTitle(cityEntity.name , displayMode: .inline)
            .onAppear(perform: _updateInFavoritesState)
        }
    }
    
    func _addToFavorites() {
        isAdding = true
        if isInFavorites {
            FirebaseAppDataHandler.removeFromFavorites(city: cityEntity) { error in
                if let error = error {
                    print("Error removing from favorites: \(error)")
                }
                _updateInFavoritesState()
            }
        } else {
            FirebaseAppDataHandler.addToFavorites(city: cityEntity) { error in
                if let error = error {
                    print("Error adding to favorites: \(error)")
                }
                _updateInFavoritesState()
            }
        }
    }

    func _updateInFavoritesState() {
        FirebaseAppDataHandler.checkIfInFavorites(city: cityEntity) { isInFavorites, error in
            if let error = error {
                print("Error checking if in favorites: \(error)")
            } else {
                self.isInFavorites = isInFavorites
            }
            self.isAdding = false
        }
    }
}

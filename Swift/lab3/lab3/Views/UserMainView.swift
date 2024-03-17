//
//  UserMainView.swift
//  lab3
//
//  Created by dumonten on 15/3/24.
//

import SwiftUI
import Firebase
import FirebaseDatabase

struct UserMainView: View {
    @State private var cities: [CityEntity] = []
    @State private var isLoading = true
    @State private var currentMessage: Message?
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    Text("Loading data, wait.")
                        .foregroundColor(Color.text)
                }
                else if cities.isEmpty {
                    Text("No data. Add something.")
                        .foregroundColor(Color.text)
                } else {
                    List(cities, id: \.id) { city in
                        NavigationLink(destination: CityView(cityEntity: city)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(city.name )
                                        .font(.headline)
                                        .foregroundColor(Color.buttonText)
                                    Text(city.country )
                                        .font(.subheadline)
                                        .foregroundColor(Color.buttonText)
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color.button)
                            .foregroundColor(Color.buttonText)
                            .cornerRadius(8)
                        }
                    }
                }
            }
            .alert(item: $currentMessage) { message in
                message.asAlert()
            }
            .navigationBarTitle("Cities", displayMode: .inline)
            .onAppear(perform: _loadCities)
        }
    }

    func _loadCities() {
        isLoading = true
        
        FirebaseAppDataHandler.getAllCities { (cityEntities, error) in
            if let error = error {
                currentMessage = Message(title: "Error fetching cities: \(error)", isError: true)
            } else {
                self.cities = cityEntities ?? []
            }
        }
        
        isLoading = false
    }
}



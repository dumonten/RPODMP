//
//  FirebaseAppDataHandler.swift
//  lab3
//
//  Created by dumonten on 15/3/24.
//

import FirebaseDatabase
import FirebaseAuth


class FirebaseAppDataHandler {
    
    static func getUserInfo(completion: @escaping (UserEntity?, Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(nil, nil)
            return
        }
        
        let ref = Database.database().reference().child("users").child(user.uid)
        ref.getData { (error, snapshot) in
            if let error = error {
                completion(nil, error)
            } else if let snapshot = snapshot.value as? [String: Any] {
                if let userEntity = UserEntity.fromJson(json: snapshot) {
                    completion(userEntity, nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, nil)
            }
        }
    }
    
    static func updateUserInfo(name: String?,
                               surname: String?,
                               age: Int?,
                               dateOfBirth: String?,
                               address: String?,
                               male: String?,
                               phoneNumber: String?,
                               favCity: String?,
                               favCountry: String?,
                               favorites: [String]?,
                               completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(nil)
            return
        }
        
        var userInfo: [String: Any] = [:]
        
        if let name = name {
            userInfo["name"] = name
        }
        if let surname = surname {
            userInfo["surname"] = surname
        }
        if let age = age {
            userInfo["age"] = age
        }
        if let dateOfBirth = dateOfBirth {
            userInfo["date_of_birthday"] = dateOfBirth
        }
        if let address = address {
            userInfo["address"] = address
        }
        if let male = male {
            userInfo["male"] = male
        }
        if let phoneNumber = phoneNumber {
            userInfo["phone_number"] = phoneNumber
        }
        if let favCity = favCity {
            userInfo["fav_city"] = favCity
        }
        if let favCountry = favCountry {
            userInfo["fav_country"] = favCountry
        }
        if let favorites = favorites {
            userInfo["favorites"] = favorites
        }
        
        let ref = Database.database().reference().child("users").child(user.uid)
        ref.updateChildValues(userInfo) { (error, ref) in
            if let error = error {
                print("Error updating user info: \(error)")
                completion(error)
            } else {
                print("User info updated successfully")
                completion(nil)
            }
        }
    }

    
    static func getFavorites(completion: @escaping ([CityEntity]?, Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(nil, nil)
            return
        }
        
        let userRef = Database.database().reference().child("users").child(user.uid)
        userRef.getData { (error, snapshot) in
            if let error = error {
                print("Error fetching user data: \(error)")
                completion(nil, error)
            } else if let snapshot = snapshot.value as? [String: Any],
                      let favorites = snapshot["favorites"] as? [String] {
                var cityEntities: [CityEntity] = []
                let group = DispatchGroup()
                
                for favorite in favorites {
                    if favorite == "null" {
                        continue
                    }
                    group.enter()
                    let cityRef = Database.database().reference().child("cities").child(favorite)
                    cityRef.getData { (error, snapshot) in
                        if let error = error {
                            print("Error fetching city data: \(error)")
                        } else if let snapshot = snapshot.value as? [String: Any] {
                            if let cityEntity = CityEntity.fromJson(json: snapshot) {
                                cityEntities.append(cityEntity)
                            }
                        }
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    completion(cityEntities, nil)
                }
            } else {
                completion(nil, nil)
            }
        }
    }
    
    static func addToFavorites(city: CityEntity, completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(nil)
            return
        }
        
        let userRef = Database.database().reference().child("users").child(user.uid)
        userRef.child("favorites").getData { (error, snapshot) in
            if let error = error {
                print("Error fetching favorites: \(error)")
                completion(error)
            } else if var favorites = snapshot.value as? [String] {
                // Проверяем, не добавлен ли город уже в избранное
                if !favorites.contains(city.id) {
                    favorites.append(city.id)
                    userRef.child("favorites").setValue(favorites) { (error, ref) in
                        if let error = error {
                            print("Error updating favorites: \(error)")
                            completion(error)
                        } else {
                            print("City added to favorites successfully")
                            completion(nil)
                        }
                    }
                } else {
                    print("City is already in favorites")
                    completion(nil)
                }
            } else {
                // Если избранных городов еще нет, создаем новый список
                let newFavorites = [city.id]
                userRef.child("favorites").setValue(newFavorites) { (error, ref) in
                    if let error = error {
                        print("Error updating favorites: \(error)")
                        completion(error)
                    } else {
                        print("City added to favorites successfully")
                        completion(nil)
                    }
                }
            }
        }
    }
    
    static func removeFromFavorites(city: CityEntity, completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(nil)
            return
        }
        
        let userRef = Database.database().reference().child("users").child(user.uid)
        userRef.child("favorites").getData { (error, snapshot) in
            if let error = error {
                print("Error fetching favorites: \(error)")
                completion(error)
            } else if var favorites = snapshot.value as? [String] {
                // Удаляем город из избранного
                if let index = favorites.firstIndex(of: city.id) {
                    favorites.remove(at: index)
                    userRef.child("favorites").setValue(favorites) { (error, ref) in
                        if let error = error {
                            print("Error updating favorites: \(error)")
                            completion(error)
                        } else {
                            print("City removed from favorites successfully")
                            completion(nil)
                        }
                    }
                } else {
                    print("City is not in favorites")
                    completion(nil)
                }
            } else {
                print("No favorites found")
                completion(nil)
            }
        }
    }
    
    static func getAllCities(completion: @escaping ([CityEntity]?, Error?) -> Void) {
        let citiesRef = Database.database().reference().child("cities")
        citiesRef.getData { (error, snapshot) in
            if let error = error {
                print("Error fetching cities: \(error)")
                completion(nil, error)
            } else if let snapshot = snapshot.value as? [String: Any] {
                var cityEntities: [CityEntity] = []
                for (key, value) in snapshot {
                    if let cityJson = value as? [String: Any] {
                        // Создаем новый словарь, добавляя id города
                        var cityDataWithId = cityJson
                        cityDataWithId["id"] = key
                        if let cityEntity = CityEntity.fromJson(json: cityDataWithId) {
                            cityEntities.append(cityEntity)
                        }
                    }
                }
                completion(cityEntities, nil)
            } else {
                completion(nil, nil)
            }
        }
    }
    
    static func checkIfInFavorites(city: CityEntity, completion: @escaping (Bool, Error?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false, nil)
            return
        }
        
        let userRef = Database.database().reference().child("users").child(user.uid)
        userRef.child("favorites").getData { (error, snapshot) in
            if let error = error {
                print("Error fetching favorites: \(error)")
                completion(false, error)
            } else if let favorites = snapshot.value as? [String] {
                completion(favorites.contains(city.id), nil)
            } else {
                completion(false, nil)
            }
        }
    }
}


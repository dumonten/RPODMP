//
//  UserEntity.swift
//  lab3
//
//  Created by dumonten on 15/3/24.
//

import Foundation

struct UserEntity: Codable {
    var name: String
    var age: Int
    var email: String
    var surname: String
    var address: String
    var phoneNumber: String
    var dateOfBirthday: String
    var male: String
    var favCountry: String
    var favCity: String
    var favorites: [String]
    
    // Конструктор, принимающий все поля
    init(name: String, age: Int, email: String, surname: String, address: String, phoneNumber: String, dateOfBirthday: String, male: String, favCountry: String, favCity: String) {
        self.name = name
        self.age = age
        self.email = email
        self.surname = surname
        self.address = address
        self.phoneNumber = phoneNumber
        self.dateOfBirthday = dateOfBirthday
        self.male = male
        self.favCountry = favCountry
        self.favCity = favCity
        self.favorites = []
    }
    
    // Конструктор, принимающий только email
    init(email: String) {
        self.name = ""
        self.age = 0
        self.email = email
        self.surname = ""
        self.address = ""
        self.phoneNumber = ""
        self.dateOfBirthday = ""
        self.male = ""
        self.favCountry = ""
        self.favCity = ""
        self.favorites = []
    }
    
    func toJson() -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        if let jsonData = try? encoder.encode(self),
           let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            return json
        }
        return [:]
    }
    
    static func fromJson(json: [String: Any]) -> UserEntity? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            let user = try decoder.decode(UserEntity.self, from: jsonData)
            return user
        } catch let error {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }

}


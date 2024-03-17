//
//  CityEntity.swift
//  lab3
//
//  Created by dumonten on 15/3/24.
//

import Foundation

struct CityEntity: Codable {
    var id: String
    var name: String
    var description: String
    var yearOfFoundation: Int
    var country: String
    var imageUrls: [String]
    
    init() {
        self.id = ""
        self.name = ""
        self.description = ""
        self.yearOfFoundation = 0
        self.country = ""
        self.imageUrls = []
    }
    
    init(id: String, name: String, description: String, yearOfFoundation: Int, country: String, imageUrls: [String]) {
        self.id = id
        self.name = name
        self.description = description
        self.yearOfFoundation = yearOfFoundation
        self.country = country
        self.imageUrls = imageUrls
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
    
    static func fromJson(json: [String: Any]) -> CityEntity? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []),
           let city = try? decoder.decode(CityEntity.self, from: jsonData) {
            return city
        }
        return nil
    }
}

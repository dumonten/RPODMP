package com.example.kotlinclass

class ModelCity {
    var id: String = ""
    var name: String = ""
    var description: String = ""
    var yearOfFoundation: Int = 0
    var country: String = ""
    var imageUrls: List<String> = emptyList()

    constructor()

    constructor(id: String, name: String, description: String, yearOfFoundation: Int,
                country: String, imageUrls: List<String>) {
        this.id = id
        this.name = name
        this.description = description
        this.yearOfFoundation = yearOfFoundation
        this.country = country
        this.imageUrls = imageUrls
    }

}
//
//  Pet.swift
//  PetFinderApp
//
//  Created by user240565 on 20/11/23.
//

import Foundation


// MARK: - PetsResponse
struct PetsResponse: Codable {
    let pets: [Pet]
    let pagination: Pagination
    
    enum CodingKeys: String, CodingKey {
        case pets = "animals"
        case pagination
    }
}

// MARK: - PetResponse
struct PetResponse: Codable {
    let pet: Pet
    
    enum CodingKeys: String, CodingKey {
        case pet = "animal"
        //case pagination
    }
}


// MARK: - Pet
struct Pet: Codable, Identifiable {
    let id: Int
    let organizationID: String
    let url: String?
    let type, species: String?
    let breeds: Breeds?
    let age, gender, size: String
    let name: String
    let description: String?
    let photos: [Photo]?
    let contact: Contact?

    enum CodingKeys: String, CodingKey {
        case id
        case organizationID = "organization_id"
        case url, type, species, breeds, age, gender, size, name, description ,photos, contact
    }
    
    static var example: Pet {
        return Pet(id: 1, organizationID: "NJ333", url: "", type: "dog", species: "", breeds: Breeds(primary: "Golden"), age: "Adult", gender: "Female", size: "large", name: "Rocky", description: "Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta) desconocido usó una galería de textos y los mezcló de tal manera que logró hacer un libro de textos especimen Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta) desconocido usó una galería de textos y los mezcló de tal manera que logró hacer un libro de textos especimen v Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta) desconocido usó una galería de textos y los mezcló de tal manera que logró hacer un libro de textos especimen Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta) desconocido usó una galería de textos y los mezcló de tal manera que logró hacer un libro de textos especimen Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta) desconocido usó una galería de textos y los mezcló de tal manera que logró hacer un libro de textos especimen" ,photos: [Photo(small: "", medium: "", large: "", full: "")], contact: Contact(email: "email@email.com", phone: "555-555-555", address: Address(address1: "Calle 13", address2: "Calle 12", city: "Almeria", state: "", postcode: "", country: "")))
    }
    
    var characteristics: [Characteristic] {
        [
          Characteristic(id: 1, title: size, label: "size"),
          Characteristic(id: 2, title: age, label: "age"),
          Characteristic(id: 3, title: gender, label: "gender")
        ]
      }
}

// MARK: - Breeds
struct Breeds: Codable {
    let primary: String?
}

// MARK: - Pagination
struct Pagination: Codable {
    let countPerPage, totalCount, currentPage, totalPages: Int
    //let links: PaginationLinks

    enum CodingKeys: String, CodingKey {
        case countPerPage = "count_per_page"
        case totalCount = "total_count"
        case currentPage = "current_page"
        case totalPages = "total_pages"
        //case links = "_links"
    }
}

// MARK: - PaginationLinks
struct PaginationLinks: Codable {
}

//MARK: - PetType
struct PetTypeResponse: Codable {
    let types: [TypeElement]
}

// MARK: - TypeElement
struct TypeElement: Codable {
    let name: String
    
    static var typeExample: TypeElement {
        return TypeElement(name: "dog")
    }
}

struct Characteristic: Identifiable {
    var id: Int
    var title: String
    var label: String
}



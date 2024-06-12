//
//  Organization.swift
//  PetFinderApp
//
//  Created by user240565 on 20/11/23.
//

import Foundation


// MARK: - OrganizationsResponse
struct OrganizationsResponse: Codable {
    let organizations: [Organization]
}

// MARK: - OrganizationResponse
struct OrganizationResponse: Codable {
    let organization: Organization
}


// MARK: - Organization
struct Organization: Codable {
    let id: String
    let name: String
    let email, phone: String?
    let address: Address?
    let hours: Hours
    let url: String
    let missionStatement: String?
    let photos: [Photo]?

    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, address, hours, url
        case missionStatement = "mission_statement"
        case photos
    }
    
    static var example: Organization {
        return Organization(id: "NJ333", name: "NJ333", email: "email@email.com", phone: "555-555-555", address: Address(address1: "Calle 13", address2: "Calle 12 ", city: "Almería", state: "", postcode: "", country: ""), hours: Hours(monday: "12:00", tuesday: "11:00 - 12:00", wednesday: "11:00 - 12:00", thursday: "11:00 - 12:00", friday: "", saturday: "", sunday: "11:00 - 12:00"), url: "", missionStatement: "Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta) desconocido usó una galería de textos y los mezcló de tal manera que logró hacer un libro de textos especimen Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta) desconocido usó una galería de textos y los mezcló de tal manera que logró hacer un libro de textos especimen v Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta) desconocido usó una galería de textos y los mezcló de tal manera que logró hacer un libro de textos especimen Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta) desconocido usó una galería de textos y los mezcló de tal manera que logró hacer un libro de textos especimen Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta) desconocido usó una galería de textos y los mezcló de tal manera que logró hacer un libro de textos especimen", photos: [Photo(small: "", medium: "", large: "", full: "")])
    }
    
    var hoursList: [Hour] {
        [
            Hour(id: 1, title: hours.monday ?? "--", label: "monday"),
            Hour(id: 2, title: hours.tuesday ?? "--", label: "tuesday"),
            Hour(id: 3, title: hours.wednesday ?? "--", label: "wednesday"),
            Hour(id: 4, title: hours.thursday ?? "--", label: "thursday"),
            Hour(id: 5, title: hours.friday ?? "--", label: "friday"),
            Hour(id: 6, title: hours.saturday ?? "--", label: "saturday"),
            Hour(id: 7, title: hours.sunday ?? "--", label: "sunday")
        ]
      }
}

// MARK: - Hours
struct Hours: Codable {
    let monday, tuesday, wednesday, thursday: String?
    let friday, saturday, sunday: String?
}

struct Hour: Identifiable {
    var id: Int
    var title: String
    var label: String
}

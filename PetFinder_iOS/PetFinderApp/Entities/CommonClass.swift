//
//  CommonClass.swift
//  PetFinderApp
//
//  Created by user240565 on 20/11/23.
//

import Foundation

// MARK: - Contact
struct Contact: Codable {
    let email, phone: String?
    let address: Address?
}

// MARK: - Address
struct Address: Codable {
    let address1, address2: String?
    let city, state, postcode, country: String?
}

// MARK: - Photo
struct Photo: Codable {
    let small, medium, large, full: String
}

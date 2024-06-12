//
//  MockOrganizationsRemoteService.swift
//  PetFinderApp
//
//  Created by user240565 on 24/11/23.
//

import Foundation


struct MockOrganizationsRemoteService: OrganizationsRemoteService {
    func getOrganizations(token: String) async throws -> [Organization] {
        [
            .init(
                id: "NJ333",
                name: "NJ333",
                email: "email@email.com",
                phone: "555-555-555",
                address: Address(
                    address1: "",
                    address2: "",
                    city: "Almería",
                    state: "",
                    postcode: "",
                    country: ""),
                hours: Hours(monday: "", tuesday: "", wednesday: "", thursday: "", friday: "", saturday: "", sunday: ""),
                url: "",
                missionStatement: "Descripción sobre la organizacion",
                photos: [Photo(small: "",
                               medium: "",
                               large: "",
                               full: "")]
            ),
            .init(
                id: "HWJAT",
                name: "HWJAT",
                email: "email@email.com",
                phone: "555-555-555",
                address: Address(
                    address1: "",
                    address2: "",
                    city: "Almería",
                    state: "",
                    postcode: "",
                    country: ""),
                hours: Hours(monday: "", tuesday: "", wednesday: "", thursday: "", friday: "", saturday: "", sunday: ""),
                url: "",
                missionStatement: "Descripción sobre la organizacion",
                photos: [Photo(small: "",
                               medium: "",
                               large: "",
                               full: "")])
        ]
    }
    
    func getOrganization(token: String, url: String) async throws -> Organization {
        return .example
    }
    
}

//
//  MockPetsRemoteService.swift
//  PetFinderApp
//
//  Created by user240565 on 20/11/23.
//

import Foundation

struct MockPetsRemoteService: PetsRemoteService {
    
    func getPets(token: String, type: String, page: Int) async throws -> PetsResponse {
        .init(pets: [Pet(id: 1,
                         organizationID: "NJ333",
                         url: "",
                         type: "dog",
                         species: "",
                         breeds: Breeds(primary: ""),
                         age: "Adult",
                         gender: "Female",
                         size: "",
                         name: "Rocky",
                         description: "",
                         photos: [Photo(small: "",
                                        medium: "",
                                        large: "",
                                        full: "")],
                         contact: Contact(email: "email@email.com",
                                          phone: "555-555-555",
                                          address: Address(address1: "Calle 13",
                                                           address2: "Calle 12",
                                                           city: "Almeria",
                                                           state: "",
                                                           postcode: "",
                                                           country: ""))),
                     
                     Pet(id: 2,
                         organizationID: "NJ333",
                         url: "",
                         type: "cat",
                         species: "",
                         breeds: Breeds(primary: ""),
                         age: "Adult",
                         gender: "Male",
                         size: "",
                         name: "Misi",
                         description: "",
                         photos: [Photo(small: "",
                                        medium: "",
                                        large: "",
                                        full: "")],
                         contact: Contact(email: "email@email.com",
                                          phone: "555-555-555",
                                          address: Address(address1: "Calle 13",
                                                           address2: "Calle 12",
                                                           city: "Almeria",
                                                           state: "",
                                                           postcode: "",
                                                           country: ""))),
                     Pet(id: 3,
                         organizationID: "NJ333",
                         url: "",
                         type: "cat",
                         species: "",
                         breeds: Breeds(primary: ""),
                         age: "Adult",
                         gender: "Male",
                         size: "",
                         name: "Miso",
                         description: "",
                         photos: [Photo(small: "",
                                        medium: "",
                                        large: "",
                                        full: "")],
                         contact: Contact(email: "email@email.com",
                                          phone: "555-555-555",
                                          address: Address(address1: "Calle 13",
                                                           address2: "Calle 12",
                                                           city: "Almeria",
                                                           state: "",
                                                           postcode: "",
                                                           country: "")))],
              pagination: Pagination(countPerPage: 1, totalCount: 1, currentPage: 1, totalPages: 1))
    }
    
    func getPet(token: String, petId: Int) async throws -> Pet {
        return .example
    }
    
    func getPetTypes(token: String) async throws -> [TypeElement] {
        return [TypeElement(name: "all"),TypeElement(name: "dog"),TypeElement(name: "cat"),TypeElement(name: "rabbit")]
    }
}


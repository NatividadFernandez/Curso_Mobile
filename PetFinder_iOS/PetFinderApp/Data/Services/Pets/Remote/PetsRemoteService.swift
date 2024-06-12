//
//  PetsRemoteService.swift
//  PetFinderApp
//
//  Created by user240565 on 20/11/23.
//

import Foundation

protocol PetsRemoteService {
    func getPets(token: String, type: String, page: Int) async throws -> PetsResponse
    func getPet(token: String, petId: Int) async throws -> Pet
    func getPetTypes(token: String) async throws -> [TypeElement]
}

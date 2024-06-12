//
//  OrganizationsRemoteService.swift
//  PetFinderApp
//
//  Created by user240565 on 24/11/23.
//

import Foundation

protocol OrganizationsRemoteService {
    func getOrganizations(token: String) async throws -> [Organization]
    func getOrganization(token: String, url: String) async throws -> Organization
}

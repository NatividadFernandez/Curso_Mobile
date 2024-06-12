//
//  TokenRemoteService.swift
//  PetFinderApp
//
//  Created by user240565 on 20/11/23.
//

import Foundation

protocol TokenLocalService {
    func saveAccessToken(token: Token) async throws
    func getAccessToken() async throws -> String
}

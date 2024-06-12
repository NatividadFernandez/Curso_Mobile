//
//  TokenRemoteService.swift
//  PetFinderApp
//
//  Created by user240565 on 21/11/23.
//

import Foundation

protocol TokenRemoteService {
    func createAccessToken() async throws -> Token
}


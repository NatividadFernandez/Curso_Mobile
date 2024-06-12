//
//  Token.swift
//  PetFinderApp
//
//  Created by user240565 on 20/11/23.
//

import Foundation

struct Token: Codable {
    let tokenType: String?
    let expiresIn: Int?
    let accessToken: String?
    
    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case accessToken = "access_token"
    }
    
    static var example: Token {
        return Token(tokenType: "", expiresIn: 0, accessToken: "")
    }
}

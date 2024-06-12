//
//  UserDefaultsTokenLocalService.swift
//  PetFinderApp
//
//  Created by user240565 on 20/11/23.
//

import Foundation

struct UserDefaultsTokenLocalService: TokenLocalService {
    
    private let tokenKey = "auth_token"
    
     func saveAccessToken(token: Token) async throws {
        
        do {
            let data = try JSONEncoder().encode(token)
            UserDefaults.standard.set(data,forKey: tokenKey)
        } catch {
            print("Error al codificar y almacenar el token: \(error)")
        }
        
    }
    
     func getAccessToken() async throws -> String {
        guard let data = UserDefaults.standard.data(forKey: tokenKey) else {
            return ""
        }
        
        let token = try JSONDecoder().decode(Token.self, from: data)
        return token.accessToken ?? ""
    }
    
}

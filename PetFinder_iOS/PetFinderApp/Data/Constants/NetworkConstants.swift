//
//  NetworkConstant.swift
//  PetFinderApp
//
//  Created by user240565 on 20/11/23.
//

import Foundation

struct NetworkConstants {
    static let clientId = "RYHZfNQzfknAAaIzGmsh1K8z2cHX485pLWTQMDwvuyyxPDLHT9"
    static let clientSecret = "XkvPGumoamjFgHAxrfvYHaTr5GEaUYrLHqxpshq8"
    static let grantType = "client_credentials"
    static let authNetworkUrl = "https://api.petfinder.com/v2/oauth2/token"
    static let bodyParams = [
        "client_id": clientId,
        "client_secret": clientSecret,
        "grant_type": grantType
    ]
    
    static let baseUrl = "https://api.petfinder.com/v2/"  
    static let petsNetworkUrl = "\(baseUrl)animals"
    static let petTypeNetworkUrl = "\(baseUrl)types"
    static let organizationsNetworkUrl = "\(baseUrl)organizations"
    
    
    
}

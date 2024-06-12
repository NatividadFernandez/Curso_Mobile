//
//  NetworkError.swift
//  PetFinderApp
//
//  Created by user240565 on 20/11/23.
//

import Foundation

enum NetworkError: Error {
    case nilResponse
    case badUrl
    case encoding
    case response(Int)
}

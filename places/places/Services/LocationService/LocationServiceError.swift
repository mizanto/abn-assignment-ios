//
//  LocationServiceError.swift
//  Places
//
//  Created by Sergey Bendak on 2.12.2024.
//

import Foundation

enum LocationServiceError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .invalidResponse:
            return "The response from the server was invalid."
        case .decodingError(let error):
            return "Failed to decode the response: \(error.localizedDescription)"
        case .networkError(let error):
            return "A network error occurred: \(error.localizedDescription)"
        }
    }
}

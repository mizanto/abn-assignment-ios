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
    case clientError(Int) // HTTP Coodes 400-499
    case serverError(Int) // HTTP Coodes 500-599
    case unexpectedStatusCode(Int) // Other HTTP Coodes

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
        case .clientError(let code):
            return "The client error with status code \(code)."
        case .serverError(let code):
            return "The server error with status code \(code)."
        case .unexpectedStatusCode(let code):
            return "The server returned an unexpected status code: \(code)."
        }
    }
}

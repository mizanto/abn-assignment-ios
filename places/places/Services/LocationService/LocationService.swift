//
//  LocationService.swift
//  Places
//
//  Created by Sergey Bendak on 2.12.2024.
//

import Foundation

protocol LocationServiceProtocol {
    func fetchLocations() async throws -> [NetworkLocation]
}

class LocationService: LocationServiceProtocol {
    private let baseURL: String = "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json"
    
    func fetchLocations() async throws -> [NetworkLocation] {
        logger.debug("Fetching locations...", category: .locationService)
        guard let url = URL(string: baseURL) else {
            logger.error("Invalid URL: \(self.baseURL)", category: .locationService)
            throw LocationServiceError.invalidURL
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                logger.error("Invalid response received from server", category: .locationService)
                throw LocationServiceError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                logger.debug("Successful response: \(httpResponse.statusCode)", category: .locationService)
                return try decodeLocations(data)
            case 400...499:
                logger.error("Client error: \(httpResponse.statusCode)", category: .locationService)
                throw LocationServiceError.clientError(httpResponse.statusCode)
            case 500...599:
                logger.error("Server error: \(httpResponse.statusCode)", category: .locationService)
                throw LocationServiceError.serverError(httpResponse.statusCode)
            default:
                logger.error("Unexpected HTTP status code: \(httpResponse.statusCode)", category: .locationService)
                throw LocationServiceError.unexpectedStatusCode(httpResponse.statusCode)
            }
        } catch let error as DecodingError {
            logger.error("Decoding error: \(error)", category: .locationService)
            throw LocationServiceError.decodingError(error)
        } catch {
            logger.error("Network error: \(error)", category: .locationService)
            throw LocationServiceError.networkError(error)
        }
    }
    
    private func decodeLocations(_ data: Data) throws -> [NetworkLocation] {
        struct LocationsResponse: Decodable {
            let locations: [NetworkLocation]
        }

        guard let rawData = try? JSONDecoder().decode(LocationsResponse.self, from: data) else {
            throw LocationServiceError.invalidResponse
        }
        return rawData.locations
    }
}


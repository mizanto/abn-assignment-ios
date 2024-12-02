//
//  LocationService.swift
//  Places
//
//  Created by Sergey Bendak on 2.12.2024.
//

import Foundation
import OSLog

fileprivate let logger = Logger(subsystem: "com.sergeibendak.places", category: "LocationService")

protocol LocationServiceProtocol {
    func fetchLocations() async throws -> [NetworkLocation]
}

class LocationService: LocationServiceProtocol {
    private let baseURL: String = "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json"
    
    func fetchLocations() async throws -> [NetworkLocation] {
        logger.debug("Fetching locations...")
        guard let url = URL(string: baseURL) else {
            logger.error("Invalid URL: \(self.baseURL)")
            throw LocationServiceError.invalidURL
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            // TODO: add http codes processing
            return try decodeLocations(data)
        } catch let error as DecodingError {
            logger.error("Decoding error: \(error)")
            throw LocationServiceError.decodingError(error)
        } catch {
            logger.error("Network error: \(error)")
            throw LocationServiceError.networkError(error)
        }
    }
    
    private func decodeLocations(_ data: Data) throws -> [NetworkLocation] {
        struct LocationsResponse: Decodable {
            let locations: [NetworkLocation]
        }

        guard let response = try? JSONDecoder().decode(LocationsResponse.self, from: data) else {
            throw LocationServiceError.invalidResponse
        }
        return response.locations
    }
}


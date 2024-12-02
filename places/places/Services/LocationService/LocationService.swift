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
        guard let url = URL(string: baseURL) else {
            throw LocationServiceError.invalidURL
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            // TODO: add http codes processing
            return try decodeLocations(data)
        } catch let error as DecodingError {
            throw LocationServiceError.decodingError(error)
        } catch {
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


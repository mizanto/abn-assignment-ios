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
    private enum Constant {
        static let baseURL = "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json"
    }
    
    private let session: URLSession
    private let baseURL: String
    
    init(baseURL: String = Constant.baseURL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    func fetchLocations() async throws -> [NetworkLocation] {
        logger.debug("Fetching locations...", category: .locationService)

        guard let url = URL(string: baseURL), url.scheme != nil else {
            logger.error("Invalid URL: \(self.baseURL)", category: .locationService)
            throw LocationServiceError.invalidURL
        }

        do {
            let (data, response) = try await session.data(from: url)
            
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
        } catch let error as LocationServiceError {
            throw error
        } catch {
            logger.error("Network error: \(error)", category: .locationService)
            throw LocationServiceError.networkError(error)
        }
    }
    
    private func decodeLocations(_ data: Data) throws -> [NetworkLocation] {
        struct LocationsResponse: Decodable {
            let locations: [NetworkLocation]
        }

        do {
            let decodedData = try JSONDecoder().decode(LocationsResponse.self, from: data)
            return decodedData.locations
        } catch {
            throw LocationServiceError.decodingError(error)
        }
    }
}


//
//  MockLocationService.swift
//  Places
//
//  Created by Sergey Bendak on 4.12.2024.
//

import Foundation
@testable import Places

final class MockLocationService: LocationServiceProtocol {
    var locations: [Places.NetworkLocation] = []
    var error: Error?
    private(set) var fetchLocationsCallCount = 0
    
    func fetchLocations() async throws -> [Places.NetworkLocation] {
        fetchLocationsCallCount += 1
        if let error { throw error }
        return locations
    }
}

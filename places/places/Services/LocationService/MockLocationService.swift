//
//  MockLocationService.swift
//  Places
//
//  Created by Sergey Bendak on 4.12.2024.
//

#if DEBUG
import Foundation

final class MockLocationService: LocationServiceProtocol {
    var locations: [NetworkLocation] = []
    var error: Error?
    private(set) var fetchLocationsCallCount = 0
    
    func fetchLocations() async throws -> [NetworkLocation] {
        fetchLocationsCallCount += 1
        if let error { throw error }
        return locations
    }
}
#endif

//
//  DisplayLocation.swift
//  Places
//
//  Created by Sergey Bendak on 2.12.2024.
//

import Foundation

struct DisplayLocation: Equatable, Identifiable, CustomStringConvertible {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    
    var description: String {
        "\nDisplayLocation(name: \(name), latitude: \(latitude), longitude: \(longitude))"
    }
    
    init(_ networkLocation: NetworkLocation) {
        self.name = networkLocation.name ?? "Unknown Location"
        self.latitude = networkLocation.latitude
        self.longitude = networkLocation.longitude
    }
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    /*
     Custom implementation of Equatable.
     This implementation is primarily used for testing purposes to compare content-based
     equality of `DisplayLocation` instances. It ignores the `id` property, which is a unique
     identifier and would make all instances unequal. For other use cases, such as identifying
     unique instances, rely on the `id` property.
     */
    static func == (lhs: DisplayLocation, rhs: DisplayLocation) -> Bool {
        lhs.name == rhs.name &&
        lhs.latitude == rhs.latitude &&
        lhs.longitude == rhs.longitude
    }
}

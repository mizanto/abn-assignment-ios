//
//  DisplayLocation.swift
//  Places
//
//  Created by Sergey Bendak on 2.12.2024.
//

import Foundation

struct DisplayLocation: Identifiable, CustomStringConvertible {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    
    var description: String {
        "\nDisplayLocation(id: \(id), name: \(name), latitude: \(latitude), longitude: \(longitude))"
    }
    
    init(_ networkLocation: NetworkLocation) {
        self.name = networkLocation.name ?? "Unknown Location"
        self.latitude = networkLocation.latitude
        self.longitude = networkLocation.longitude
    }
}

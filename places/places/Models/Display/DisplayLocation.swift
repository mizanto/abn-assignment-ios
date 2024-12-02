//
//  DisplayLocation.swift
//  Places
//
//  Created by Sergey Bendak on 2.12.2024.
//

import Foundation

struct DisplayLocation: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    
    init(_ networkLocation: NetworkLocation) {
        self.name = networkLocation.name ?? "Unknown Location"
        self.latitude = networkLocation.latitude
        self.longitude = networkLocation.longitude
    }
}

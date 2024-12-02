//
//  NetworkLocation.swift
//  Places
//
//  Created by Sergey Bendak on 2.12.2024.
//

import Foundation

struct NetworkLocation: Decodable {
    let name: String?
    let latitude: Double
    let longitude: Double

    private enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "long"
    }
}

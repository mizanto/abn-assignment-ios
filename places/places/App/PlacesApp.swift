//
//  PlacesApp.swift
//  Places
//
//  Created by Sergey Bendak on 2.12.2024.
//

import SwiftUI

@main
struct PlacesApp: App {
    let locationService = LocationService()
    
    var body: some Scene {
        WindowGroup {
            LocationsBuilder.build(locationService: locationService)
        }
    }
}

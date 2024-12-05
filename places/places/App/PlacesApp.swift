//
//  PlacesApp.swift
//  Places
//
//  Created by Sergey Bendak on 2.12.2024.
//

import SwiftUI

public let logger = LoggerProvider.shared

@main
struct PlacesApp: App {
    let locationService = LocationService()
    let locationsView: LocationsView<LocationsViewModel>
    
    init() {
        if CommandLine.arguments.contains("-mockLoadingState") {
            locationsView = LocationsBuilder.build(mock: .loading)
        } else if CommandLine.arguments.contains("-mockSuccessState") {
            locationsView = LocationsBuilder.build(mock: .success)
        } else if CommandLine.arguments.contains("-mockEmptyState") {
            locationsView = LocationsBuilder.build(mock: .empty)
        } else if CommandLine.arguments.contains("-mockErrorState") {
            locationsView = LocationsBuilder.build(mock: .error)
        } else {
            locationsView = LocationsBuilder.build(locationService: locationService)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            locationsView
        }
    }
}

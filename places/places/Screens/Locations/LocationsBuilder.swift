//
//  LocationsBuilder.swift
//  Places
//
//  Created by Sergey Bendak on 3.12.2024.
//

import SwiftUI

struct LocationsBuilder {
    @MainActor
    static func build(locationService: LocationServiceProtocol) -> some View {
        let viewModel = LocationsViewModel(locationService: locationService)
        return LocationsView(viewModel: viewModel)
    }
}

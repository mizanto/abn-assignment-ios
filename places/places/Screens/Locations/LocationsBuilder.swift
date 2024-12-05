//
//  LocationsBuilder.swift
//  Places
//
//  Created by Sergey Bendak on 3.12.2024.
//

import SwiftUI

struct LocationsBuilder {
    enum Mock {
        case loading
        case empty
        case success
        case error
    }
    
    @MainActor
    static func build(locationService: LocationServiceProtocol) -> LocationsView<LocationsViewModel> {
        let viewModel = LocationsViewModel(locationService: locationService)
        return LocationsView(viewModel: viewModel)
    }
    
    @MainActor
    static func build(mock: Mock) -> LocationsView<LocationsViewModel> {
        let viewModel: LocationsViewModel
        
        switch mock {
        case .loading:
            viewModel = LocationsViewModel.mockLoadingState()
        case .empty:
            viewModel = LocationsViewModel.mockEmptyState()
        case .success:
            viewModel = LocationsViewModel.mockSuccessState()
        case .error:
            viewModel = LocationsViewModel.mockErrorState()
        }
        return LocationsView(viewModel: viewModel)
    }
}

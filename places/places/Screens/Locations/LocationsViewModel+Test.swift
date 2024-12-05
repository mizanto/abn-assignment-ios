//
//  LocationsViewModel+Test.swift
//  Places
//
//  Created by Sergey Bendak on 4.12.2024.
//

#if DEBUG
import Foundation

extension LocationsViewModel {
    static func mockLoadingState() -> LocationsViewModel {
        let mockService = MockLocationService()
        let viewModel = LocationsViewModel(locationService: mockService)
        viewModel.state = .loading
        return viewModel
    }
    
    static func mockSuccessState() -> LocationsViewModel {
        let mockService = MockLocationService()
        mockService.locations = [
            NetworkLocation(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215),
            NetworkLocation(name: "Mumbai", latitude: 19.0823998, longitude: 72.8111468)
        ]
        let viewModel = LocationsViewModel(locationService: mockService)
        return viewModel
    }
    
    static func mockEmptyState() -> LocationsViewModel {
        let mockService = MockLocationService()
        let viewModel = LocationsViewModel(locationService: mockService)
        return viewModel
    }
    
    static func mockErrorState() -> LocationsViewModel {
        let mockService = MockLocationService()
        mockService.error = LocationServiceError.invalidURL
        let viewModel = LocationsViewModel(locationService: mockService)
        return viewModel
    }
}
#endif

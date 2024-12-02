//
//  LocationsViewModel.swift
//  Places
//
//  Created by Sergey Bendak on 2.12.2024.
//

import Foundation
import Combine
import UIKit

@MainActor
class LocationsViewModel: ObservableObject {
    @Published var state: ScreenState = .loading

    private let locationService: LocationServiceProtocol

    init(locationService: LocationServiceProtocol = LocationService()) {
        self.locationService = locationService
    }

    func loadLocations() {
        Task {
            state = .loading
            do {
                let fetchedLocations = try await locationService.fetchLocations()
                state = .success(fetchedLocations.map(DisplayLocation.init))
            } catch {
                let message = processError(error: error)
                state = .error(message)
            }
        }
    }

    func openInWikipedia(location: DisplayLocation) {
        if let url = url(for: location), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            // TODO: replace with logger
            print("Wikipedia app is not installed or the URL is invalid.")
        }
    }
    
    private func url(for location: DisplayLocation) -> URL? {
        let urlString = "wikipedia://places?latitude=\(location.latitude)&longitude=\(location.longitude)"
        return URL(string: urlString)
    }
    
    private func processError(error: Error) -> String {
        // TODO: move strings to localizable.strings
        if let locationError = error as? LocationServiceError {
            switch locationError {
            case .invalidURL:
                return "Invalid URL. Please contact support."
            case .invalidResponse:
                return "Invalid server response. Please try again later."
            case .decodingError:
                return "Failed to decode locations. Please contact support."
            case .networkError(let networkError):
                return "Network error: \(networkError.localizedDescription). Please check your internet connection."
            }
        } else {
            return "An unexpected error occurred. Please try again."
        }
    }
}

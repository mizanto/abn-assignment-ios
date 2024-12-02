//
//  LocationsViewModel.swift
//  Places
//
//  Created by Sergey Bendak on 2.12.2024.
//

import Foundation
import Combine
import UIKit
import OSLog

fileprivate let logger = Logger(subsystem: "com.sergeibendak.places", category: "LocationsViewModel")

@MainActor
class LocationsViewModel: ObservableObject {
    @Published var state: ScreenState = .loading

    private let locationService: LocationServiceProtocol

    init(locationService: LocationServiceProtocol = LocationService()) {
        self.locationService = locationService
    }

    func loadLocations() {
        logger.debug("Loading locations...")
        Task {
            state = .loading
            do {
                let fetchedLocations = try await locationService.fetchLocations()
                let displayLocations = fetchedLocations.map(DisplayLocation.init)
                logger.debug("Locations loaded: \(displayLocations.count)")
                state = .success(displayLocations)
            } catch {
                let message = processError(error: error)
                logger.error("Error loading locations: \(message)")
                state = .error(message)
            }
        }
    }
    
    func retryLoadingLocations() {
        logger.debug("Retrying loading locations...")
        loadLocations()
    }

    func openInWikipedia(location: DisplayLocation) {
        if let url = url(for: location), UIApplication.shared.canOpenURL(url) {
            logger.debug("Opening Wikipedia app for: \(location)")
            UIApplication.shared.open(url)
        } else {
            // TODO: show thomething to the user
            logger.error("Error opening Wikipedia app for \(location)")
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

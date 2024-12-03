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
protocol LocationsViewModelProtocol: ObservableObject {
    var state: ScreenState { get }
    var isPresentingCustomLocation: Bool { get set }
    
    func onAppear()
    func onReload()
    func locationTapped(_ location: DisplayLocation)
    func locationSelected(latitude: Double?, longitude: Double?)
    func validateCoordinates(latitude: String?, longitude: String?) -> Bool
}

@MainActor
class LocationsViewModel: LocationsViewModelProtocol {
    @Published var state: ScreenState = .loading
    @Published var isPresentingCustomLocation = false

    private let locationService: LocationServiceProtocol

    init(locationService: LocationServiceProtocol) {
        self.locationService = locationService
    }
    
    func onAppear() {
        logger.debug("On appear...")
        loadLocations()
    }
    
    func onReload() {
        logger.debug("Reloading locations...")
        loadLocations()
    }
    
    func locationTapped(_ location: DisplayLocation) {
        logger.debug("Location tapped: \(location)")
        openInWikipedia(latitude: location.latitude, longitude: location.longitude)
    }
    
    func locationSelected(latitude: Double?, longitude: Double?) {
        guard let latitude, let longitude else {
            // TODO: show message to the user
            logger.debug("Invalid location")
            return
        }
        logger.debug("Location selected: \(latitude), \(longitude)")
        openInWikipedia(latitude: latitude, longitude: longitude)
    }
    
    func validateCoordinates(latitude: String?, longitude: String?) -> Bool {
        Double(latitude ?? "") != nil && Double(longitude ?? "") != nil
    }

    private func loadLocations() {
        logger.debug("Loading locations...")
        Task {
            state = .loading
            do {
                let fetchedLocations = try await locationService.fetchLocations()
                let displayLocations = fetchedLocations.map(DisplayLocation.init)
                logger.debug("Locations loaded: \(displayLocations)")
                state = .success(displayLocations)
            } catch {
                let message = processError(error: error)
                logger.error("Error loading locations: \(message)")
                state = .error(message)
            }
        }
    }
    
    private func openInWikipedia(latitude: Double, longitude: Double) {
        if let url = url(latitude: latitude, longitude: longitude), UIApplication.shared.canOpenURL(url) {
            logger.debug("Opening Wikipedia app for: \(latitude), \(longitude)")
            UIApplication.shared.open(url)
        } else {
            // TODO: show thomething to the user
            logger.error("Error opening Wikipedia app for: \(latitude), \(longitude)")
        }
    }
    
    private func url(latitude: Double, longitude: Double) -> URL? {
        let urlString = "wikipedia://places?latitude=\(latitude)&longitude=\(longitude)"
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

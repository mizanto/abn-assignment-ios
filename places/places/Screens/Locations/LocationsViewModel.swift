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
    var showErrorSnackbar: Bool { get set }
    var snackbarErrorMessage: String { get }
    
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
    @Published var showErrorSnackbar = false
    
    var snackbarErrorMessage: String = ""

    private let locationService: LocationServiceProtocol
    private let urlOpener: URLOpener

    init(locationService: LocationServiceProtocol, urlOpener: URLOpener = DefaultURLOpener()) {
        self.locationService = locationService
        self.urlOpener = urlOpener
    }
    
    func onAppear() {
        logger.debug("On appear...", category: .locationsViewModel)
        loadLocations()
    }
    
    func onReload() {
        logger.debug("Reloading locations...", category: .locationsViewModel)
        loadLocations()
    }
    
    func locationTapped(_ location: DisplayLocation) {
        logger.debug("Location tapped: \(location)", category: .locationsViewModel)
        openInWikipedia(latitude: location.latitude, longitude: location.longitude)
    }
    
    func locationSelected(latitude: Double?, longitude: Double?) {
        guard let latitude, let longitude else {
            presentErrorSnackbar(message: NSLocalizedString("error_wrong_coordinates", comment: ""))
            logger.debug("Invalid location", category: .locationsViewModel)
            return
        }
        logger.debug("Location selected: \(latitude), \(longitude)", category: .locationsViewModel)
        openInWikipedia(latitude: latitude, longitude: longitude)
    }
    
    func validateCoordinates(latitude: String?, longitude: String?) -> Bool {
        Double(latitude ?? "") != nil && Double(longitude ?? "") != nil
    }

    private func loadLocations() {
        logger.debug("Loading locations...", category: .locationsViewModel)
        Task {
            state = .loading
            do {
                let fetchedLocations = try await locationService.fetchLocations()
                let displayLocations = fetchedLocations.map(DisplayLocation.init)
                logger.debug("Locations loaded: \(displayLocations)", category: .locationsViewModel)
                state = .success(displayLocations)
            } catch {
                let message = processError(error: error)
                logger.error("Error loading locations: \(message)", category: .locationsViewModel)
                state = .error(message)
            }
        }
    }
    
    private func openInWikipedia(latitude: Double, longitude: Double) {
        guard let url = url(latitude: latitude, longitude: longitude) else {
            logger.error("Error opening Wikipedia app for: \(latitude), \(longitude)", category: .locationsViewModel)
            presentErrorSnackbar(message: NSLocalizedString("error_wrong_coordinates", comment: ""))
            return
        }
        
        if urlOpener.canOpenURL(url) {
            logger.debug("Opening Wikipedia app for: \(latitude), \(longitude)", category: .locationsViewModel)
            urlOpener.open(url)
        } else {
            logger.error("Error opening Wikipedia app for: \(latitude), \(longitude)", category: .locationsViewModel)
            presentErrorSnackbar(message: NSLocalizedString("error_wrong_coordinates", comment: ""))
        }
    }
    
    private func url(latitude: Double, longitude: Double) -> URL? {
        let urlString = "wikipedia://places?latitude=\(latitude)&longitude=\(longitude)"
        return URL(string: urlString)
    }
    
    private func presentErrorSnackbar(message: String) {
        snackbarErrorMessage = message
        showErrorSnackbar = true
    }
    
    private func processError(error: Error) -> String {
        if let locationError = error as? LocationServiceError {
            switch locationError {
            case .invalidURL:
                return NSLocalizedString("error_invalid_url", comment: "")
            case .invalidResponse:
                return NSLocalizedString("error_invalid_response", comment: "")
            case .decodingError:
                return NSLocalizedString("error_decoding", comment: "")
            case .networkError(_):
                return NSLocalizedString("error_network", comment: "")
            case .clientError:
                return NSLocalizedString("error_client", comment: "")
            case .serverError:
                return NSLocalizedString("error_server", comment: "")
            default:
                return NSLocalizedString("error_unexpected", comment: "")
            }
        } else {
            return NSLocalizedString("error_unexpected", comment: "")
        }
    }
}

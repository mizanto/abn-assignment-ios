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
    
    var title: String { get }
    var loadingMessage: String { get }
    var emptyMessage: String { get }
    var retryButtonTitle: String { get }
    var footerText: String { get }
    var customLocationButtonTitle: String { get }
    var snackbarErrorMessage: String { get }
    
    func onAppear()
    func onReload()
    func locationTapped(_ location: DisplayLocation)
    func locationSelected(latitude: Double?, longitude: Double?)
    func latitudeValidator(_ latitude: String?) -> Bool
    func longitudeValidator(_ longitude: String?) -> Bool
}

@MainActor
class LocationsViewModel: LocationsViewModelProtocol {
    @Published var state: ScreenState = .loading
    @Published var isPresentingCustomLocation = false
    @Published var showErrorSnackbar = false
    
    let title: String = NSLocalizedString("navigation_title_places", comment: "")
    let loadingMessage: String = NSLocalizedString("loading_locations_message", comment: "")
    let emptyMessage: String = NSLocalizedString("empty_locations_message", comment: "")
    let retryButtonTitle: String = NSLocalizedString("retry_button_title", comment: "")
    let footerText: String = NSLocalizedString("footer_locations_message", comment: "")
    let customLocationButtonTitle: String = NSLocalizedString("custom_location_button_title", comment: "")
    
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
    
    func latitudeValidator(_ latitude: String?) -> Bool {
        guard let lat = parseCoordinate(latitude), (-90...90).contains(lat) else {
            return false
        }
        return true
    }
    
    func longitudeValidator(_ longitude: String?) -> Bool {
        guard let lon = parseCoordinate(longitude), (-180...180).contains(lon) else {
            return false
        }
        return true
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
    
    private func parseCoordinate(_ string: String?) -> Double? {
        guard let string = string else { return nil }
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        return formatter.number(from: string)?.doubleValue
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
        var components = URLComponents()
        components.scheme = "wikipedia"
        components.host = "places"
        components.queryItems = [
            URLQueryItem(name: "latitude", value: "\(latitude)"),
            URLQueryItem(name: "longitude", value: "\(longitude)")
        ]
        return components.url
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

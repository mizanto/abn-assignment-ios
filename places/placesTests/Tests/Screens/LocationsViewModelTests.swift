//
//  LocationsViewModelTests.swift
//  PlacesTests
//
//  Created by Sergey Bendak on 4.12.2024.
//

import XCTest
@testable import Places

final class LocationsViewModelTests: XCTestCase {
    private var service: MockLocationService!
    private var viewModel: LocationsViewModel!
    
    private let testLocations = [
        NetworkLocation(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215),
        NetworkLocation(name: "Mumbai", latitude: 19.0823998, longitude: 72.8111468)
    ]
    
    override func setUpWithError() throws {
        service = MockLocationService()
    }
    
    override func tearDownWithError() throws {
        service = nil
        viewModel = nil
    }
    
    private func setupViewModel(
        with locations: [NetworkLocation] = [],
        error: Error? = nil
    ) async -> LocationsViewModel {
        service.locations = locations
        service.error = error
        return await LocationsViewModel(locationService: service)
    }
    
    // New helper function to wait for the state to change
    private func waitForState(
        _ expectedState: ScreenState,
        timeout: TimeInterval = 3.0,
        file: StaticString = #file,
        line: UInt = #line
    ) async throws {
        let startTime = Date()
        let timeoutDate = startTime.addingTimeInterval(timeout)
        
        while Date() < timeoutDate {
            if await viewModel.state == expectedState {
                return
            }
            try await Task.sleep(nanoseconds: 100_000_000) // Sleep for 0.1 seconds
        }
        XCTFail("Timeout waiting for state to be \(expectedState)", file: file, line: line)
    }
    
    func testInitialState_StateIsLoading() async throws {
        viewModel = await setupViewModel()
        let state = await viewModel.state
        XCTAssertEqual(state, ScreenState.loading)
    }
    
    func testOnAppear_StateUpdatesToSuccess() async throws {
        // Arrange
        let expectedLocations = testLocations.map(DisplayLocation.init)
        viewModel = await setupViewModel(with: testLocations)
        
        // Act
        await viewModel.onAppear()
        
        // Assert
        try await waitForState(.success(expectedLocations))
        XCTAssertEqual(service.fetchLocationsCallCount, 1, "fetchLocations should be called exactly once")
    }
    
    func testOnReload_StateUpdatesToSuccess() async throws {
        // Arrange
        let expectedLocations = testLocations.map(DisplayLocation.init)
        viewModel = await setupViewModel(with: testLocations)
        
        // Act
        await viewModel.onReload()
        
        // Assert
        try await waitForState(.success(expectedLocations))
        XCTAssertEqual(service.fetchLocationsCallCount, 1, "fetchLocations should be called exactly once")
    }
    
    func testOnReload_StateUpdatesToError() async throws {
        // Arrange
        service.error = LocationServiceError.invalidResponse
        viewModel = await setupViewModel(error: service.error)
        
        // Act
        await viewModel.onReload()
        
        // Assert
        let expectedErrorMessage = NSLocalizedString("error_invalid_response", comment: "")
        try await waitForState(.error(expectedErrorMessage))
        XCTAssertEqual(service.fetchLocationsCallCount, 1, "fetchLocations should be called exactly once")
    }
    
    func testOnAppear_StateUpdatesToSuccessWithEmptyLocations() async throws {
        viewModel = await setupViewModel(with: [])
        await viewModel.onAppear()
        try await waitForState(.success([]))
    }
    
    func testOnAppear_StateUpdatesToError_InvalidURL() async throws {
        viewModel = await setupViewModel(error: LocationServiceError.invalidURL)
        await viewModel.onAppear()
        let expectedErrorMessage = NSLocalizedString("error_invalid_url", comment: "")
        try await waitForState(.error(expectedErrorMessage))
    }
    
    func testOnAppear_StateUpdatesToError_InvalidResponse() async throws {
        viewModel = await setupViewModel(error: LocationServiceError.invalidResponse)
        await viewModel.onAppear()
        let expectedErrorMessage = NSLocalizedString("error_invalid_response", comment: "")
        try await waitForState(.error(expectedErrorMessage))
    }
    
    func testOnAppear_StateUpdatesToError_DecodingError() async throws {
        let decodingError = NSError(domain: "Decoding", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON"])
        viewModel = await setupViewModel(error: LocationServiceError.decodingError(decodingError))
        await viewModel.onAppear()
        let expectedErrorMessage = NSLocalizedString("error_decoding", comment: "")
        try await waitForState(.error(expectedErrorMessage))
    }
    
    func testOnAppear_StateUpdatesToError_NetworkError() async throws {
        let networkError = NSError(domain: "Network", code: -1, userInfo: [NSLocalizedDescriptionKey: "No Internet Connection"])
        viewModel = await setupViewModel(error: LocationServiceError.networkError(networkError))
        await viewModel.onAppear()
        let expectedErrorMessage = NSLocalizedString("error_network", comment: "")
        try await waitForState(.error(expectedErrorMessage))
    }
    
    func testOnAppear_StateUpdatesToError_ClientError() async throws {
        viewModel = await setupViewModel(error: LocationServiceError.clientError(400))
        await viewModel.onAppear()
        let expectedErrorMessage = NSLocalizedString("error_client", comment: "")
        try await waitForState(.error(expectedErrorMessage))
    }
    
    func testOnAppear_StateUpdatesToError_ServerError() async throws {
        viewModel = await setupViewModel(error: LocationServiceError.serverError(500))
        await viewModel.onAppear()
        let expectedErrorMessage = NSLocalizedString("error_server", comment: "")
        try await waitForState(.error(expectedErrorMessage))
    }
    
    func testOnAppear_StateUpdatesToError_UnexpectedStatusCode() async throws {
        viewModel = await setupViewModel(error: LocationServiceError.unexpectedStatusCode(600))
        await viewModel.onAppear()
        let expectedErrorMessage = NSLocalizedString("error_unexpected", comment: "")
        try await waitForState(.error(expectedErrorMessage))
    }
    
    func testOnAppear_StateUpdatesToError_UnknownError() async throws {
        let unknownError = NSError(domain: "Unknown", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown Error"])
        viewModel = await setupViewModel(error: unknownError)
        await viewModel.onAppear()
        let expectedErrorMessage = NSLocalizedString("error_unexpected", comment: "")
        try await waitForState(.error(expectedErrorMessage))
    }
    
    func testLocationSelected_ValidCoordinates() async throws {
        // Arrange
        viewModel = await setupViewModel()
        let latitude = 52.3547498
        let longitude = 4.8339215

        // Act
        await viewModel.locationSelected(latitude: latitude, longitude: longitude)

        // Assert
        let isSnackbarShown = await viewModel.showErrorSnackbar
        XCTAssertFalse(isSnackbarShown, "Snackbar should not be shown for valid coordinates.")
    }
    
    func testLocationSelected_InvalidCoordinates() async throws {
        // Arrange
        viewModel = await setupViewModel()
        let latitude: Double? = nil
        let longitude: Double? = nil

        // Act
        await viewModel.locationSelected(latitude: latitude, longitude: longitude)

        // Assert
        let snackbarMessage = await viewModel.snackbarErrorMessage
        let isSnackbarShown = await viewModel.showErrorSnackbar
        XCTAssertEqual(snackbarMessage, NSLocalizedString("error_wrong_coordinates", comment: ""))
        XCTAssertTrue(isSnackbarShown, "Snackbar should be shown for invalid coordinates.")
    }
    
    func testValidateCoordinates_Valid() async {
        // Arrange
        viewModel = await LocationsViewModel(locationService: service)

        // Act
        let isValid = await viewModel.validateCoordinates(latitude: "52,3547498", longitude: "4,8339215")

        // Assert
        XCTAssertTrue(isValid, "Coordinates should be valid.")
    }

    func testValidateCoordinates_Invalid() async {
        // Arrange
        viewModel = await LocationsViewModel(locationService: service)

        // Act
        let isValid = await viewModel.validateCoordinates(latitude: "Invalid", longitude: "4.8339215")

        // Assert
        XCTAssertFalse(isValid, "Coordinates should be invalid if latitude or longitude cannot be converted to Double.")
    }
    
    func testLocationTapped_ValidURL() async throws {
        // Arrange
        let mockURLOpener = MockURLOpener()
        viewModel = await LocationsViewModel(locationService: service, urlOpener: mockURLOpener)
        let location = DisplayLocation(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215)

        // Act
        await viewModel.locationTapped(location)

        // Assert
        XCTAssertTrue(mockURLOpener.openCalled, "open should be called")
        XCTAssertEqual(
            mockURLOpener.urlToOpen?.absoluteString,
            "wikipedia://places?latitude=\(location.latitude)&longitude=\(location.longitude)"
        )
    }

    func testLocationTapped_InvalidURL() async throws {
        // Arrange
        let mockURLOpener = MockURLOpener()
        mockURLOpener.canOpen = false
        viewModel = await LocationsViewModel(locationService: service, urlOpener: mockURLOpener)
        let location = DisplayLocation(name: "InvalidLocation", latitude: -999.0, longitude: -999.0)

        // Act
        await viewModel.locationTapped(location)

        // Assert
        XCTAssertFalse(mockURLOpener.openCalled, "open should not be called for invalid URL")
        let snackbarMessage = await viewModel.snackbarErrorMessage
        XCTAssertEqual(snackbarMessage, NSLocalizedString("error_wrong_coordinates", comment: ""))
    }
    
    func testLocationSelected_ValidLocation() async throws {
        // Arrange
        let mockURLOpener = MockURLOpener()
        viewModel = await LocationsViewModel(locationService: service, urlOpener: mockURLOpener)
        let latitude = 52.3547498
        let longitude = 4.8339215
        
        // Act
        await viewModel.locationSelected(latitude: latitude, longitude: longitude)
        
        // Assert
        XCTAssertTrue(mockURLOpener.openCalled, "open should be called")
        XCTAssertEqual(
            mockURLOpener.urlToOpen?.absoluteString,
            "wikipedia://places?latitude=\(latitude)&longitude=\(longitude)"
        )
    }
    
    func testLocationSelected_InvalidLocation() async throws {
        // Arrange
        let mockURLOpener = MockURLOpener()
        viewModel = await LocationsViewModel(locationService: service, urlOpener: mockURLOpener)
        let latitude: Double? = nil
        let longitude: Double? = nil
        
        // Act
        await viewModel.locationSelected(latitude: latitude, longitude: longitude)
        
        // Assert
        XCTAssertFalse(mockURLOpener.openCalled, "open should not be called for invalid URL")
        let snackbarMessage = await viewModel.snackbarErrorMessage
        XCTAssertEqual(snackbarMessage, NSLocalizedString("error_wrong_coordinates", comment: ""))
    }
}

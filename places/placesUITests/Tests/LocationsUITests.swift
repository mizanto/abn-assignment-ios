//
//  LocationsUITests.swift
//  PlacesUITests
//
//  Created by Sergey Bendak on 4.12.2024.
//

import XCTest
@testable import Places

final class LocationsUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testLocationsList_DisplaysCorrectly() {
        // Arrange
        let app = XCUIApplication()
        app.launchArguments += ["-mockSuccessState"]
        app.launch()

        let locations = [
            ("Amsterdam", "52,354750° 4,833922°"),
            ("Mumbai", "19,082400° 72,811147°")
        ]

        // Act & Assert
        let list = app.collectionViews["locations_view_list"]
        XCTAssertTrue(list.exists, "Locations list must be displayed.")

        for (name, coordinates) in locations {
            let row = list.buttons["location_row_\(name)"]
            XCTAssertTrue(row.exists, "Location row for '\(name)' must be displayed.")

            let nameText = row.staticTexts["location_row_name_\(name)"]
            XCTAssertTrue(nameText.exists, "Name text for '\(name)' must be displayed.")
            XCTAssertEqual(nameText.label, name, "Name text must match '\(name)'.")

            let coordinatesText = row.staticTexts["location_row_coordinates_\(name)"]
            XCTAssertTrue(coordinatesText.exists, "Coordinates text for '\(name)' must be displayed.")
            XCTAssertEqual(coordinatesText.label, coordinates, "Coordinates text must match '\(coordinates)'.")
        }
    }
    
    func testEmptyLocationsState() {
        // Arrange
        let app = XCUIApplication()
        app.launchArguments += ["-mockEmptyState"]
        app.launch()
        let expectedMessage = LocalizedString("empty_locations_message")
        let expectedButtonTitle = LocalizedString("retry_button_title")

        // Act & Assert
        XCTAssertTrue(app.images["placeholder_view_icon"].exists, "Icon must be displayed.")
        
        let message = app.staticTexts["placeholder_view_message"]
        XCTAssertTrue(message.exists, "Message must be displayed.")
        XCTAssertEqual(message.label, expectedMessage, "Message must be correct and equal to localizable text.")
        
        let actionButton = app.buttons["placeholder_view_action_button"]
        XCTAssertTrue(actionButton.exists, "Action button must be displayed.")
        XCTAssertEqual(actionButton.label, expectedButtonTitle, "Action button text must be correct.")
    }
    
    func testErrorPlaceholderState() {
        // Arrange
        let app = XCUIApplication()
        app.launchArguments += ["-mockErrorState"]
        app.launch()
        let expectedMessage = LocalizedString("error_invalid_url")
        let expectedButtonTitle = LocalizedString("retry_button_title")

        // Act & Assert
        let icon = app.images["placeholder_view_icon"]
        XCTAssertTrue(icon.exists, "Error icon must be displayed.")

        let message = app.staticTexts["placeholder_view_message"]
        XCTAssertTrue(message.exists, "Error message must be displayed.")
        XCTAssertEqual(message.label, expectedMessage, "Error message must match the localizable text.")

        let actionButton = app.buttons["placeholder_view_action_button"]
        XCTAssertTrue(actionButton.exists, "Retry button must be displayed.")
        XCTAssertEqual(actionButton.label, expectedButtonTitle, "Retry button text must match the localizable text.")
    }
    
//    func testCustomLocationView_AppearsOnCustomLocationButtonTap() {
//        // Arrange
//        let app = XCUIApplication()
//        app.launchArguments += ["-mockSuccessState"]
//        app.launch()
//
//        // Act
//        let customLocationButton = app.buttons["locations_view_custom_location_button"]
//        XCTAssertTrue(customLocationButton.exists, "Custom location button must be displayed.")
//        
//        customLocationButton.tap()
//        
//        print(app.debugDescription)
//        
//        // Assert
//        let customLocationView = app.collectionViews["locations_view_custom_location_view"]
//        XCTAssertTrue(customLocationView.exists, "Custom location view must be displayed after tapping the button.")
//        
//        // Check elements in CustomLocationView
//        let latitudeField = customLocationView.textFields["custom_latitude_field"]
//        XCTAssertTrue(latitudeField.exists, "Latitude text field must be present in CustomLocationView.")
//        XCTAssertNotNil(latitudeField.placeholderValue, "Latitude text field placeholder must be set.")
//        XCTAssertEqual(latitudeField.placeholderValue!, LocalizedString("custom_latitude_placeholder"),
//                      "Latitude text field placeholder must be set.")
//        
//        let longitudeField = customLocationView.textFields["custom_longitude_field"]
//        XCTAssertTrue(longitudeField.exists, "Longitude text field must be present in CustomLocationView.")
//        XCTAssertNotNil(longitudeField.placeholderValue, "Longitude text field placeholder must be set.")
//        XCTAssertEqual(longitudeField.placeholderValue!, LocalizedString("custom_longitude_placeholder"),
//                      "Longitude text field placeholder must be set.")
//        
//        let submitButton = customLocationView.buttons["custom_open_location_button"]
//        XCTAssertTrue(submitButton.exists, "Submit button must be present in CustomLocationView.")
//        XCTAssertEqual(submitButton.label, LocalizedString("open_custom_location_button_title"),
//                       "Submit button label must be set.")
//        XCTAssertFalse(submitButton.isEnabled, "Submit button must be disabled initially.")
//        
//        // Act: Input valid values into the text fields
//        latitudeField.tap()
//        latitudeField.typeText("52,354750")
//        
//        longitudeField.tap()
//        longitudeField.typeText("4,833922")
//        
//        // Assert: Check if the submit button is enabled after entering valid input
//        XCTAssertTrue(submitButton.isEnabled, "Submit button must be enabled after entering valid input.")
//    }
    
    func testCustomLocationView_AppearsOnCustomLocationButtonTap() {
        // Arrange
        let app = XCUIApplication()
        app.launchArguments += ["-mockSuccessState"]
        app.launch()

        // Act
        let customLocationButton = app.buttons["locations_view_custom_location_button"]
        XCTAssertTrue(customLocationButton.exists, "Custom location button must be displayed.")

        customLocationButton.tap()

        // Assert
        let customLocationView = app.collectionViews["locations_view_custom_location_view"]
        XCTAssertTrue(customLocationView.waitForExistence(timeout: 5), "Custom location view must be displayed after tapping the button.")

        // Check elements in CustomLocationView
        let latitudeField = customLocationView.textFields["custom_latitude_field"]
        XCTAssertTrue(latitudeField.exists, "Latitude text field must be present in CustomLocationView.")
        XCTAssertEqual(latitudeField.placeholderValue, LocalizedString("custom_latitude_placeholder"), "Latitude text field placeholder must be set.")

        let longitudeField = customLocationView.textFields["custom_longitude_field"]
        XCTAssertTrue(longitudeField.exists, "Longitude text field must be present in CustomLocationView.")
        XCTAssertEqual(longitudeField.placeholderValue, LocalizedString("custom_longitude_placeholder"), "Longitude text field placeholder must be set.")

        let submitButton = customLocationView.buttons["custom_open_location_button"]
        XCTAssertTrue(submitButton.exists, "Submit button must be present in CustomLocationView.")
        XCTAssertEqual(submitButton.label, LocalizedString("open_custom_location_button_title"), "Submit button label must be set.")
        XCTAssertFalse(submitButton.isEnabled, "Submit button must be disabled initially.")
    }
    
    func testCustomLocationView_ShowsErrorMessages_ForInvalidCoordinates() {
        // Arrange
        let app = XCUIApplication()
        app.launchArguments += ["-mockSuccessState"]
        app.launch()

        let customLocationButton = app.buttons["locations_view_custom_location_button"]
        XCTAssertTrue(customLocationButton.exists, "Custom location button must be displayed.")
        customLocationButton.tap()

        let customLocationView = app.collectionViews["locations_view_custom_location_view"]
        XCTAssertTrue(customLocationView.waitForExistence(timeout: 5), "Custom location view must be displayed after tapping the button.")

        let latitudeField = customLocationView.textFields["custom_latitude_field"]
        let longitudeField = customLocationView.textFields["custom_longitude_field"]
        let submitButton = customLocationView.buttons["custom_open_location_button"]

        // Act: Enter invalid latitude
        latitudeField.tap()
        latitudeField.typeText("100") // Invalid latitude (> 90)

        // Assert: Latitude error message appears
        let latitudeErrorMessage = customLocationView.staticTexts["latitude_error_message"]
        XCTAssertTrue(latitudeErrorMessage.waitForExistence(timeout: 2), "Latitude error message should appear for invalid latitude.")
        XCTAssertEqual(latitudeErrorMessage.label, LocalizedString("error_invalid_latitude"), "Latitude error message should be correct.")

        // Submit button should remain disabled
        XCTAssertFalse(submitButton.isEnabled, "Submit button should remain disabled with invalid latitude.")

        // Act: Enter invalid longitude
        longitudeField.tap()
        longitudeField.typeText("200") // Invalid longitude (> 180)

        // Assert: Longitude error message appears
        let longitudeErrorMessage = customLocationView.staticTexts["longitude_error_message"]
        XCTAssertTrue(longitudeErrorMessage.waitForExistence(timeout: 2), "Longitude error message should appear for invalid longitude.")
        XCTAssertEqual(longitudeErrorMessage.label, LocalizedString("error_invalid_longitude"), "Longitude error message should be correct.")

        // Submit button should remain disabled
        XCTAssertFalse(submitButton.isEnabled, "Submit button should remain disabled with invalid longitude.")

        // Act: Correct the latitude and longitude to valid values
        latitudeField.tap()
        latitudeField.clearAndEnterText("-45") // Valid latitude

        longitudeField.tap()
        longitudeField.clearAndEnterText("80") // Valid longitude

        // Assert: Error messages disappear
        XCTAssertFalse(latitudeErrorMessage.exists, "Latitude error message should disappear after entering valid latitude.")
        XCTAssertFalse(longitudeErrorMessage.exists, "Longitude error message should disappear after entering valid longitude.")

        // Submit button should now be enabled
        XCTAssertTrue(submitButton.isEnabled, "Submit button should be enabled after entering valid coordinates.")
    }
}

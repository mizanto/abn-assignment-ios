//
//  CustomLocationView.swift
//  Places
//
//  Created by Sergey Bendak on 2.12.2024.
//

import SwiftUI

struct CustomLocationView: View {
    @Binding var isPresented: Bool

    @State private var latitude: String = ""
    @State private var longitude: String = ""

    @State private var latitudeError: Bool = false
    @State private var longitudeError: Bool = false

    var latitudeValidator: (String?) -> Bool
    var longitudeValidator: (String?) -> Bool
    var onSubmit: (Double?, Double?) -> Void

    private var isValidInput: Bool {
        !latitude.isEmpty && !longitude.isEmpty && !latitudeError && !longitudeError
    }

    var body: some View {
        Form {
            Section {
                CoordinateInputField(
                    placeholder: NSLocalizedString("custom_latitude_placeholder", comment: ""),
                    text: $latitude,
                    hasError: $latitudeError,
                    errorMessage: NSLocalizedString("error_invalid_latitude", comment: ""),
                    validator: latitudeValidator,
                    accessibilityLabel: NSLocalizedString("accessibility_label_custom_latitude", comment: ""),
                    accessibilityHint: NSLocalizedString("accessibility_hint_custom_latitude", comment: ""),
                    accessibilityIdentifier: "custom_latitude_field",
                    errorAccessibilityIdentifier: "latitude_error_message"
                )
                
                CoordinateInputField(
                    placeholder: NSLocalizedString("custom_longitude_placeholder", comment: ""),
                    text: $longitude,
                    hasError: $longitudeError,
                    errorMessage: NSLocalizedString("error_invalid_longitude", comment: ""),
                    validator: longitudeValidator,
                    accessibilityLabel: NSLocalizedString("accessibility_label_custom_longitude", comment: ""),
                    accessibilityHint: NSLocalizedString("accessibility_hint_custom_longitude", comment: ""),
                    accessibilityIdentifier: "custom_longitude_field",
                    errorAccessibilityIdentifier: "longitude_error_message"
                )
            }
            footer: {
                InfoFooterView(NSLocalizedString("footer_custom_location_message", comment: ""))
                    .accessibilityHint(NSLocalizedString("accessibility_hint_custom_footer", comment: ""))
            }

            Section {
                Button(action: {
                    openCustomLocation()
                    isPresented = false
                }) {
                    Text(NSLocalizedString("open_custom_location_button_title", comment: ""))
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isValidInput ? .blue : .gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(!isValidInput)
                .listRowInsets(EdgeInsets())
                .accessibilityLabel(NSLocalizedString("open_custom_location_button_title", comment: ""))
                .accessibilityHint(NSLocalizedString("accessibility_hint_custom_button", comment: ""))
                .accessibilityIdentifier("custom_open_location_button")
            }
        }
    }

    private func openCustomLocation() {
        onSubmit(parseCoordinate(latitude), parseCoordinate(longitude))
    }

    private func parseCoordinate(_ string: String?) -> Double? {
        guard let string = string else { return nil }
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        return formatter.number(from: string)?.doubleValue
    }
}

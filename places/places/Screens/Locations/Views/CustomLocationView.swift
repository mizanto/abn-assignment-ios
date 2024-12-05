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
    
    var validator: (String?, String?) -> Bool
    var onSubmit: (Double?, Double?) -> Void
    
    private var isValidInput: Bool {
        validator(latitude, longitude)
    }

    var body: some View {
        Form {
            Section {
                
                TextField(NSLocalizedString("custom_latitude_placeholder", comment: ""), text: $latitude)
                    .keyboardType(.numbersAndPunctuation)
                    .accessibilityLabel(NSLocalizedString("accessibility_label_custom_latitude", comment: ""))
                    .accessibilityHint(NSLocalizedString("accessibility_hint_custom_latitude", comment: ""))
                    .accessibilityIdentifier("custom_latitude_field")
                TextField(NSLocalizedString("custom_longitude_placeholder", comment: ""), text: $longitude)
                    .keyboardType(.numbersAndPunctuation)
                    .accessibilityLabel(NSLocalizedString("accessibility_label_custom_longitude", comment: ""))
                    .accessibilityHint(NSLocalizedString("accessibility_hint_custom_longitude", comment: ""))
                    .accessibilityIdentifier("custom_longitude_field")
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
        onSubmit(Double(latitude), Double(longitude))
    }
}

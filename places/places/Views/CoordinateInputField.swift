//
//  CoordinateInputField.swift
//  Places
//
//  Created by Sergey Bendak on 5.12.2024.
//

import SwiftUI

struct CoordinateInputField: View {
    let placeholder: String
    @Binding var text: String
    @Binding var hasError: Bool
    let errorMessage: String
    let validator: (String?) -> Bool
    let accessibilityLabel: String
    let accessibilityHint: String
    let accessibilityIdentifier: String
    let errorAccessibilityIdentifier: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField(placeholder, text: $text)
                .keyboardType(.numbersAndPunctuation)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .onChange(of: text) { _, newValue in
                    hasError = !validator(newValue)
                }
                .accessibilityLabel(accessibilityLabel)
                .accessibilityHint(accessibilityHint)
                .accessibilityIdentifier(accessibilityIdentifier)

            if hasError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .accessibilityLabel(errorMessage)
                    .accessibilityIdentifier(errorAccessibilityIdentifier)
            }
        }
    }
}


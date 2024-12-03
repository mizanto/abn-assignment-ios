//
//  Snackbar.swift
//  Places
//
//  Created by Sergey Bendak on 3.12.2024.
//

import SwiftUI

struct Snackbar: View {
    enum SnackbarType {
        case success
        case error
        case message
    }

    var message: String
    var type: SnackbarType

    var body: some View {
        Text(message)
            .foregroundColor(foregroundColor)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(backgroundColor.opacity(0.9))
            .cornerRadius(16)
            .shadow(radius: 4)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(message)
            .accessibilityHint(accessibilityHint)
            .accessibilityAddTraits(.isStaticText)
    }

    private var backgroundColor: Color {
        switch type {
        case .success: return .green
        case .error: return .red
        case .message: return .gray
        }
    }

    private var foregroundColor: Color {
        switch type {
        case .success: return .white
        case .error: return .white
        case .message: return .white
        }
    }
    
    private var accessibilityHint: String {
        switch type {
        case .success:
            return NSLocalizedString("accessibility_hint_snackbar_success", comment: "")
        case .error:
            return NSLocalizedString("accessibility_hint_snackbar_error", comment: "")
        case .message:
            return NSLocalizedString("accessibility_hint_snackbar_message", comment: "")
        }
    }
}

//
//  ErrorView.swift
//  Places
//
//  Created by Sergey Bendak on 2.12.2024.
//

import SwiftUI

enum PlaceholderType {
    case error
    case empty
}

struct PlaceholderView: View {
    let type: PlaceholderType
    let message: String
    let actionTitle: String?
    let onAction: (() -> Void)?
    
    private var iconName: String {
        switch type {
        case .error:
            return "exclamationmark.triangle.fill"
        case .empty:
            return "list.bullet.rectangle.fill"
        }
    }
    
    private var iconColor: Color {
        switch type {
        case .error:
            return .red
        case .empty:
            return .gray
        }
    }
    
    private var accessibilityLabelForIcon: String {
        switch type {
        case .error:
            return NSLocalizedString("accessibility_error_icon_description", comment: "")
        case .empty:
            return NSLocalizedString("accessibility_empty_icon_description", comment: "")
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(iconColor)
                .accessibilityLabel(accessibilityLabelForIcon)
            
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .accessibilityHint(NSLocalizedString("accessibility_hint_placeholder_message", comment: ""))
            
            if let actionTitle = actionTitle, let onAction = onAction {
                Button(action: onAction) {
                    Text(actionTitle)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 64)
                }
                .accessibilityLabel(actionTitle)
                .accessibilityHint(NSLocalizedString("accessibility_hint_placeholder_action", comment: ""))
            }
            
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    PlaceholderView(
        type: .error,
        message: "Failed to load locations. Please try again.",
        actionTitle: "Retry",
        onAction: {}
    )
}

#Preview {
    PlaceholderView(
        type: .empty,
        message: "No items available.",
        actionTitle: "Reload",
        onAction: {}
    )
}

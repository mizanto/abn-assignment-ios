//
//  LoadingView.swift
//  Places
//
//  Created by Sergey Bendak on 2.12.2024.
//

import SwiftUI

struct LoadingView: View {
    let message: String
    
    init(message: String = NSLocalizedString("default_loading_message", comment: "")) {
        self.message = message
    }

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(2)

            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .accessibilityLabel(Text(message))
                .accessibilityHint(Text(NSLocalizedString("accessibility_loading_hint", comment: "")))
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
    }
}

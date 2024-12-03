//
//  InfoFooterView.swift
//  Places
//
//  Created by Sergey Bendak on 3.12.2024.
//

import SwiftUI

struct InfoFooterView: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        HStack {
            Image(systemName: "info.circle")
                .accessibilityLabel(Text(NSLocalizedString("accessibility_label_footer_icon", comment: "")))

            Text(text)
                .font(.footnote)
                .accessibilityLabel(Text(text))
        }
        .padding(.vertical, 4)
        .foregroundColor(.secondary)
        .accessibilityElement(children: .combine)
    }
}

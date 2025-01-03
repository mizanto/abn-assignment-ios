//
//  LocationRow.swift
//  Places
//
//  Created by Sergey Bendak on 2.12.2024.
//

import SwiftUI

struct LocationRow: View {
    let location: DisplayLocation
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(location.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .accessibilityIdentifier("location_row_name_\(location.name)")
                    Text("\(location.latitude)° \(location.longitude)°")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .accessibilityIdentifier("location_row_coordinates_\(location.name)")
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
            }
            .padding(.vertical, 4)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(
                String(
                    format: NSLocalizedString("accessibility_label_location_row", comment: ""),
                    location.name,
                    location.latitude,
                    location.longitude
                )
            )
            .accessibilityHint(
                NSLocalizedString("accessibility_hint_location_row", comment: "")
            )
            .accessibilityIdentifier("location_row_\(location.name)")
        }
    }
}

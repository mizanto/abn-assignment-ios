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
                    .keyboardType(.decimalPad)
                TextField(NSLocalizedString("custom_longitude_placeholder", comment: ""), text: $longitude)
                    .keyboardType(.decimalPad)
            }
            footer: {
                InfoFooterView(NSLocalizedString("footer_custom_location_message", comment: ""))
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
            }
        }
    }
    
    private func openCustomLocation() {
        onSubmit(Double(latitude), Double(longitude))
    }
}

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
                TextField("Latitude", text: $latitude)
                    .keyboardType(.decimalPad)
                TextField("Longitude", text: $longitude)
                    .keyboardType(.decimalPad)
            }
            footer: {
                InfoFooterView("Enter latitude and longitude in numerical format")
            }

            Section {
                Button(action: {
                    openCustomLocation()
                    isPresented = false
                }) {
                    Text("Open in Wikipedia")
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

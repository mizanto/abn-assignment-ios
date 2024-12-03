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
    
    var completion: (Double?, Double?) -> Void

    var body: some View {
        Form {
            Section {
                TextField("Latitude", text: $latitude)
                    .keyboardType(.decimalPad)
                TextField("Longitude", text: $longitude)
                    .keyboardType(.decimalPad)
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
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .listRowInsets(EdgeInsets())
            }
        }
    }

    private func openCustomLocation() {
        completion(Double(latitude), Double(longitude))
    }
}

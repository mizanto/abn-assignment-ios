//
//  LocationsView.swift
//  Places
//
//  Created by Sergey Bendak on 2.12.2024.
//

import SwiftUI

struct LocationsView: View {
    @StateObject private var viewModel = LocationsViewModel()

    var body: some View {
        NavigationView {
            Group {
                switch viewModel.state {
                case .loading:
                    LoadingView(message: "Loading locations, please wait...")
                case .success(let locations):
                    locationsList(locations)
                case .error(let message):
                    PlaceholderView(
                        type: .error,
                        message: message,
                        actionTitle: "Retry",
                        onAction: {
                            viewModel.onReload()
                        }
                    )
                }
            }
            .navigationTitle("Places")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    customLocationButton()
                }
            }
            .sheet(isPresented: $viewModel.isPresentingCustomLocation) {
                customLocationView()
            }
            .onAppear {
                viewModel.onAppear()
            }
        }
    }
    
    private func locationsList(_ locations: [DisplayLocation]) -> some View {
        Group {
            if locations.isEmpty {
                PlaceholderView(
                    type: .empty,
                    message: "No locations available. Add a custom location or try reloading.",
                    actionTitle: "Reload",
                    onAction: { viewModel.onReload() }
                )
            } else {
                List {
                    ForEach(locations) { location in
                        LocationRow(location: location) {
                            viewModel.locationTapped(location)
                        }
                    }
                    Section {
                        HStack {
                            Image(systemName: "info.circle")
                            Text("To open a custom location not listed above, tap the 'Custom' button and enter the coordinates.")
                                .font(.footnote)
                                .padding(.vertical, 4)
                        }
                        .foregroundColor(.secondary)
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
            }
        }
    }
    
    private func customLocationButton() -> some View {
        Button(
            action: {
                viewModel.isPresentingCustomLocation = true
            },
            label: {
                Text("Custom")
            }
        )
    }
    
    private func customLocationView() -> some View {
        CustomLocationView(isPresented: $viewModel.isPresentingCustomLocation) { latitude, longitude in
            viewModel.locationSelected(latitude: latitude, longitude: longitude)
        }
        .presentationDetents([.height(240)])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    LocationsView()
}

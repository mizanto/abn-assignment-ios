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
        // TODO: add button for custom location
        NavigationView {
            Group {
                switch viewModel.state {
                case .loading:
                    // TODO: add LoadingView
                    ProgressView("Loading...")
                case .success(let locations):
                    List(locations) { location in
                        Button(location.name) {
                            viewModel.openInWikipedia(location: location)
                        }
                    }
                case .error(let message):
                    // TODO: add ErrorView
                    Text(message)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            .navigationTitle("Places")
            .onAppear {
                viewModel.loadLocations()
            }
        }
    }
}

#Preview {
    LocationsView()
}

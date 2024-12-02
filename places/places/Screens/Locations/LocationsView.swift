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
                        LocationRow(location: location) {
                            viewModel.openInWikipedia(location: location)
                        }
                    }
                    .listStyle(PlainListStyle())
                case .error(let message):
                    ErrorView(message: message) {
                        viewModel.retryLoadingLocations()
                    }
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

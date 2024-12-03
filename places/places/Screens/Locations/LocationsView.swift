//
//  LocationsView.swift
//  Places
//
//  Created by Sergey Bendak on 2.12.2024.
//

import SwiftUI

struct LocationsView<VM: LocationsViewModelProtocol>: View {
    @StateObject private var viewModel: VM
    
    init(viewModel: VM) {
            _viewModel = StateObject(wrappedValue: viewModel)
        }

    var body: some View {
        NavigationView {
            Group {
                switch viewModel.state {
                case .loading:
                    LoadingView(message: NSLocalizedString("loading_locations_message", comment: ""))
                case .success(let locations):
                    locationsList(locations)
                case .error(let message):
                    PlaceholderView(
                        type: .error,
                        message: message,
                        actionTitle: NSLocalizedString("retry_button_title", comment: ""),
                        onAction: {
                            viewModel.onReload()
                        }
                    )
                }
            }
            .navigationTitle(NSLocalizedString("navigation_title_places", comment: ""))
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
                    message: NSLocalizedString("empty_locations_message", comment: ""),
                    actionTitle: NSLocalizedString("retry_button_title", comment: ""),
                    onAction: { viewModel.onReload() }
                )
            } else {
                List {
                    ForEach(locations) { location in
                        LocationRow(location: location) {
                            viewModel.locationTapped(location)
                        }
                    }
                    Section {}
                    footer: {
                        InfoFooterView(NSLocalizedString("footer_locations_message", comment: ""))
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
                Text(NSLocalizedString("custom_location_button_title", comment: ""))
            }
        )
    }
    
    private func customLocationView() -> some View {
        CustomLocationView(
            isPresented: $viewModel.isPresentingCustomLocation,
            validator: viewModel.validateCoordinates,
            onSubmit: viewModel.locationSelected
        )
        .presentationDetents([.height(240)])
        .presentationDragIndicator(.visible)
    }
}

//#Preview {
//    LocationsView()
//}

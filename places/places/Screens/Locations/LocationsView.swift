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
        NavigationStack {
            Group {
                switch viewModel.state {
                case .loading:
                    LoadingView(message: viewModel.loadingMessage)
                case .success(let locations):
                    locationsList(locations)
                case .error(let message):
                    PlaceholderView(
                        type: .error,
                        message: message,
                        actionTitle: viewModel.retryButtonTitle,
                        onAction: {
                            viewModel.onReload()
                        }
                    )
                }
            }
            .navigationTitle(viewModel.title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    customLocationButton()
                }
            }
            .sheet(isPresented: $viewModel.isPresentingCustomLocation) {
                customLocationView()
            }
            .snackbar(isPresented: $viewModel.showErrorSnackbar,
                      message: viewModel.snackbarErrorMessage,
                      type: .error)
            .onAppear {
                viewModel.onAppear()
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(NSLocalizedString("accessibility_label_locations_title", comment: ""))
    }
    
    private func locationsList(_ locations: [DisplayLocation]) -> some View {
        Group {
            if locations.isEmpty {
                PlaceholderView(
                    type: .empty,
                    message: viewModel.emptyMessage,
                    actionTitle: viewModel.retryButtonTitle,
                    onAction: { viewModel.onReload() }
                )
                .accessibilityIdentifier("LocationsView_EmptyPlaceholder")
            } else {
                List {
                    ForEach(locations) { location in
                        LocationRow(location: location) {
                            viewModel.locationTapped(location)
                        }
                    }
                    Section {}
                    footer: {
                        InfoFooterView(viewModel.footerText)
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
                .accessibilityIdentifier("locations_view_list")
            }
        }
    }
    
    private func customLocationButton() -> some View {
        Button(
            action: {
                viewModel.isPresentingCustomLocation = true
            },
            label: {
                Text(viewModel.customLocationButtonTitle)
            }
        )
        .accessibilityLabel(NSLocalizedString("accessibility_label_custom_location_button", comment: ""))
        .accessibilityHint(NSLocalizedString("accessibility_hint_custom_location_button", comment: ""))
        .accessibilityIdentifier("LocationsView_customLocationButton")
    }
    
    private func customLocationView() -> some View {
        CustomLocationView(
            isPresented: $viewModel.isPresentingCustomLocation,
            validator: viewModel.validateCoordinates,
            onSubmit: viewModel.locationSelected
        )
        .presentationDetents([.height(240)])
        .presentationDragIndicator(.visible)
        .accessibilityIdentifier("locations_view_custom_location_view")
    }
}

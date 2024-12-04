//
//  ScreenState.swift
//  Places
//
//  Created by Sergey Bendak on 2.12.2024.
//

enum ScreenState {
    case loading
    case success([DisplayLocation])
    case error(String)
}

extension ScreenState: Equatable {
    static func == (lhs: ScreenState, rhs: ScreenState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.success(let lhsLocations), .success(let rhsLocations)):
            return lhsLocations == rhsLocations
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError == rhsError
        default:
            return false
        }
    }
}

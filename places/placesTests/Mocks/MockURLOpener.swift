//
//  MockURLOpener.swift
//  Places
//
//  Created by Sergey Bendak on 4.12.2024.
//

import Foundation
@testable import Places

class MockURLOpener: URLOpener {
    var canOpen = true
    var openCalled = false
    var urlToOpen: URL?

    func canOpenURL(_ url: URL) -> Bool {
        return canOpen
    }

    func open(_ url: URL) {
        urlToOpen = url
        openCalled = true
    }
}

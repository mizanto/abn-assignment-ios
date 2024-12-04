//
//  URLOpener.swift
//  Places
//
//  Created by Sergey Bendak on 4.12.2024.
//

import UIKit

protocol URLOpener {
    func canOpenURL(_ url: URL) -> Bool
    func open(_ url: URL)
}

struct DefaultURLOpener: URLOpener {
    func canOpenURL(_ url: URL) -> Bool {
        UIApplication.shared.canOpenURL(url)
    }

    func open(_ url: URL) {
        UIApplication.shared.open(url)
    }
}

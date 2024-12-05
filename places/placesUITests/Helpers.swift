//
//  Utils.swift
//  Places
//
//  Created by Sergey Bendak on 5.12.2024.
//

import Foundation

func LocalizedString(_ key: String) -> String {
    let bundle = Bundle(for: LocationsUITests.self)
    return NSLocalizedString(key, bundle: bundle, comment: "")
}

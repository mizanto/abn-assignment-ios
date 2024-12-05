//
//  XCUIElement+Ext.swift
//  Places
//
//  Created by Sergey Bendak on 5.12.2024.
//

import XCTest

extension XCUIElement {
    func clearAndEnterText(_ text: String) {
        guard let currentValue = self.value as? String else {
            XCTFail("Failed to get current value of the text field.")
            return
        }
        // Move cursor to the end
        tap()
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: currentValue.count)
        typeText(deleteString)
        typeText(text)
    }
}

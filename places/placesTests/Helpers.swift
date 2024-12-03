//
//  Helpers.swift
//  Places
//
//  Created by Sergey Bendak on 3.12.2024.
//

import XCTest

func XCTAssertThrowsErrorAsync<T>(
    _ expression: @autoclosure @escaping () async throws -> T,
    _ message: String = "",
    file: StaticString = #file,
    line: UInt = #line,
    _ errorHandler: (Error) -> Void
) async {
    do {
        _ = try await expression()
        XCTFail("Expected error to be thrown, but no error was thrown", file: file, line: line)
    } catch {
        errorHandler(error)
    }
}

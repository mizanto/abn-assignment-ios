//
//  LocationServiceTests.swift
//  Places
//
//  Created by Sergey Bendak on 3.12.2024.
//

import XCTest
@testable import Places

final class LocationServiceTests: XCTestCase {
    private var service: LocationService!
    private var session: URLSession!

    override func setUp() {
        super.setUp()

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: configuration)

        service = LocationService(session: session)
    }

    override func tearDown() {
        service = nil
        session = nil
        MockURLProtocol.responseHandler = nil
        super.tearDown()
    }

    func testFetchLocations_Success() async throws {
        // Arrange
        let mockData = """
        {
            "locations": [
                { "name": "Amsterdam", "lat": 52.3547498, "long": 4.8339215 },
                { "name": "Mumbai", "lat": 19.0823998, "long": 72.8111468 }
            ]
        }
        """.data(using: .utf8)!
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        MockURLProtocol.responseHandler = { _ in
            return (mockData, mockResponse, nil)
        }

        // Act
        let locations = try await service.fetchLocations()

        // Assert
        XCTAssertEqual(locations.count, 2)
        XCTAssertEqual(locations.first?.name, "Amsterdam")
    }
    
    func testFetchEmptyLocations_Success() async throws {
        // Arrange
        let mockData = """
        {
            "locations": []
        }
        """.data(using: .utf8)!
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        MockURLProtocol.responseHandler = { _ in
            return (mockData, mockResponse, nil)
        }
        
        // Act
        let locations = try await service.fetchLocations()
        
        // Assert
        XCTAssertTrue(locations.isEmpty)
    }
    
    func testFetchLocations_InvalidURL() async throws {
        // Arrange
        let invalidURLService = LocationService(baseURL: "invalid-url")

        // Act & Assert
        await XCTAssertThrowsErrorAsync(try await invalidURLService.fetchLocations()) { error in
            XCTAssertEqual(error as? LocationServiceError, .invalidURL)
        }
    }
    
    func testFetchLocations_InvalidResponse() async throws {
        // Arrange
        let mockData = Data()
        let mockResponse = URLResponse(
            url: URL(string: "https://example.com")!,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )
        MockURLProtocol.responseHandler = { _ in
            return (mockData, mockResponse as? HTTPURLResponse, nil)
        }

        // Act & Assert
        await XCTAssertThrowsErrorAsync(try await self.service.fetchLocations()) { error in
            XCTAssertEqual(error as? LocationServiceError, .invalidResponse)
        }
    }
    
    func testFetchLocations_ClientError() async throws {
        // Arrange
        let mockData = Data()
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 400,
            httpVersion: nil,
            headerFields: nil
        )
        MockURLProtocol.responseHandler = { _ in
            return (mockData, mockResponse, nil)
        }

        // Act & Assert
        await XCTAssertThrowsErrorAsync(try await self.service.fetchLocations()) { error in
            if case let LocationServiceError.clientError(statusCode) = error {
                XCTAssertEqual(statusCode, 400)
            } else {
                XCTFail("Expected clientError, got \(error)")
            }
        }
    }
    
    
    func testFetchLocations_ServerError() async throws {
        // Arrange
        mockResponse(statusCode: 500)
        
        // Act & Assert
        await XCTAssertThrowsErrorAsync(try await self.service.fetchLocations()) { error in
            if case let LocationServiceError.serverError(statusCode) = error {
                XCTAssertEqual(statusCode, 500)
            } else {
                XCTFail("Expected serverError, got \(error)")
            }
        }
    }
    
    
    func testFetchLocations_UnexpectedStatusCode() async throws {
        // Arrange
        mockResponse(statusCode: 600)
        
        // Act & Assert
        await XCTAssertThrowsErrorAsync(try await self.service.fetchLocations()) { error in
            if case let LocationServiceError.unexpectedStatusCode(statusCode) = error {
                XCTAssertEqual(statusCode, 600)
            } else {
                XCTFail("Expected unexpectedStatusCode, got \(error)")
            }
        }
    }
    
    func testFetchLocations_DecodingError() async throws {
        // Arrange
        let invalidMockData = "Invalid JSON".data(using: .utf8)!
        mockResponse(data: invalidMockData)
        
        // Act & Assert
        await XCTAssertThrowsErrorAsync(try await self.service.fetchLocations()) { error in
            if case let LocationServiceError.decodingError(decodingError) = error {
                XCTAssertTrue(decodingError is DecodingError)
            } else {
                XCTFail("Expected decodingError, got \(error)")
            }
        }
    }
    
    func testFetchLocations_NetworkError() async throws {
        // Arrange
        let networkError = NSError(domain: "Test", code: -1, userInfo: nil)
        mockResponse(error: networkError)
        
        // Act & Assert
        await XCTAssertThrowsErrorAsync(try await self.service.fetchLocations()) { error in
            if case let LocationServiceError.networkError(underlyingError) = error,
               let nsError = underlyingError as NSError? {
                XCTAssertEqual(nsError.domain, networkError.domain)
                XCTAssertEqual(nsError.code, networkError.code)
            } else {
                XCTFail("Expected networkError, got \(error)")
            }
        }
    }
    
    private func mockResponse(
        data: Data? = nil,
        statusCode: Int = 200,
        headers: [String: String]? = nil,
        error: Error? = nil
    ) {
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: headers
        )
        MockURLProtocol.responseHandler = { _ in
            return (data, mockResponse, error)
        }
    }
}

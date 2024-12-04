//
//  MockURLProtocol.swift
//  Places
//
//  Created by Sergey Bendak on 3.12.2024.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var responseHandler: ((URLRequest) throws -> (Data?, HTTPURLResponse?, Error?))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.responseHandler else {
            fatalError("Handler is not set")
        }

        do {
            let (data, response, error) = try handler(request)

            if let error = error {
                client?.urlProtocol(self, didFailWithError: error)
            } else {
                if let response {
                    client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                } else {
                    let invalidResponse = URLResponse(
                        url: request.url!,
                        mimeType: nil,
                        expectedContentLength: 0,
                        textEncodingName: nil
                    )
                    client?.urlProtocol(self, didReceive: invalidResponse, cacheStoragePolicy: .notAllowed)
                }
                if let data = data {
                    client?.urlProtocol(self, didLoad: data)
                }
            }
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

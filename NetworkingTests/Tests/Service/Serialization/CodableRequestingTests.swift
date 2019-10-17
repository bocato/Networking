//
//  CodableRequestingTests.swift
//  NetworkingTests
//
//  Created by Eduardo Sanches Bocato on 30/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import Networking

final class CodableRequestingTests: XCTestCase {
    
    func test_requestCodable_shouldSucceed() {
        // Given
        guard let validDataToReturn = """
            {"value": "something"}
        """.data(using: .utf8) else {
            XCTFail("Could not create valid data.")
            return
        }
        let resultToReturn: Result<Data?, URLRequestError> = .success(validDataToReturn)
        let urlRequestDispatchingStub = URLRequestDispatchingStub(
            resultToReturn: resultToReturn
        )
        guard let url = URL(string: "http://www.someurl.com/") else {
            XCTFail("Could not create URL.")
            return
        }
        let request: SimpleURLRequest = .init(url: url)
        let expectedCodableResult = SomeResponse(value: "something")
        let sut = CodableRequestingService(dispatcher: urlRequestDispatchingStub)
        
        // When
        let requestCodableExpectation = expectation(description: "serializeCodableExpectation")
        var codableResult: SomeResponse?
        sut.requestCodable(request, ofType: SomeResponse.self) { result in
            do {
                codableResult = try result.get()
            } catch {
                XCTFail("`failure` was not expected.")
            }
            requestCodableExpectation.fulfill()
        }
        wait(for: [requestCodableExpectation], timeout: 1.0)

        // Then
        XCTAssertEqual(expectedCodableResult, codableResult, "Expected \(expectedCodableResult), but got \(String(describing: codableResult)).")
    }
    
}

// MARK: - Testing Helpers
private class CodableRequestingService: CodableRequesting {
    
    var dispatcher: URLRequestDispatching
    
    init(dispatcher: URLRequestDispatching) {
        self.dispatcher = dispatcher
    }
    
}

final class URLRequestDispatchingStub: URLRequestDispatching {
    
    private let resultToReturn: Result<Data?, URLRequestError>
    
    init(resultToReturn: Result<Data?, URLRequestError>) {
        self.resultToReturn = resultToReturn
    }
    
    func execute(request: URLRequestProtocol, completion: @escaping (Result<Data?, URLRequestError>) -> Void) -> URLRequestToken? {
        completion(resultToReturn)
        return nil
    }
    
}

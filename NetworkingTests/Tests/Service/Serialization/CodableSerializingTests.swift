//
//  CodableSerializingTests.swift
//  NetworkingTests
//
//  Created by Eduardo Sanches Bocato on 30/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import Networking

final class CodableSerializingTests: XCTestCase {
    
    func test_serializingNilData_shoulReturnNoDataError() {
        // Given
        let sut = SomeCodableSerializingThing()
        let resultToSerialize: Result<Data?, URLRequestError> = .success(nil)
        
        // When
        let serializeCodableExpectation = expectation(description: "serializeCodableExpectation")
        var errorThrown: Error?
        sut.serializeCodable(resultToSerialize, responseType: SomeResponse.self) { result in
            do {
                _ = try result.get()
                XCTFail("`success` was not expected.")
            } catch {
                errorThrown = error
            }
            serializeCodableExpectation.fulfill()
        }
        wait(for: [serializeCodableExpectation], timeout: 1.0)

        // Then
        XCTAssertNotNil(errorThrown, "An error, should have been thrown.")
        guard case .noData = errorThrown as? NetworkingError else {
            XCTFail("Invalid error found, expected `URLRequestError.noData`.")
            return
        }
    }
    
    func test_serializingValidData_shoulReturnValidCodableResult() {
        // Given
        let sut = SomeCodableSerializingThing()
        guard let validData = """
            {"value": "something"}
        """.data(using: .utf8) else {
            XCTFail("Could not create valid data.")
            return
        }
        let resultToSerialize: Result<Data?, URLRequestError> = .success(validData)
        let expectedCodableResult = SomeResponse(value: "something")
        
        // When
        let serializeCodableExpectation = expectation(description: "serializeCodableExpectation")
        var codableResult: SomeResponse?
        sut.serializeCodable(resultToSerialize, responseType: SomeResponse.self) { result in
            do {
                codableResult = try result.get()
            } catch {
                XCTFail("`failure` was not expected.")
            }
            serializeCodableExpectation.fulfill()
        }
        wait(for: [serializeCodableExpectation], timeout: 1.0)

        // Then
        XCTAssertEqual(expectedCodableResult, codableResult, "Expected \(expectedCodableResult), but got \(String(describing: codableResult)).")
    }
    
    func test_serializingInvalidData_shouldReturnSerializationError() {
        // Given
        let sut = SomeCodableSerializingThing()
        guard let invalidData = """
            {"value: invalid}
        """.data(using: .utf8) else {
            XCTFail("Could not create valid data.")
            return
        }
        let resultToSerialize: Result<Data?, URLRequestError> = .success(invalidData)
        
        // When
        // When
        let serializeCodableExpectation = expectation(description: "serializeCodableExpectation")
        var errorThrown: Error?
        sut.serializeCodable(resultToSerialize, responseType: SomeResponse.self) { result in
            do {
                _ = try result.get()
                XCTFail("`success` was not expected.")
            } catch {
                errorThrown = error
            }
            serializeCodableExpectation.fulfill()
        }
        wait(for: [serializeCodableExpectation], timeout: 1.0)

        // Then
        XCTAssertNotNil(errorThrown, "An error, should have been thrown.")
        guard case .serializationError = errorThrown as? NetworkingError else {
            XCTFail("Invalid error found, expected `URLRequestError.serializationError`.")
            return
        }
    }
    
    func test_serializingResultWithFailure_shoulReturnURLRequestError() {
        // Given
        let sut = SomeCodableSerializingThing()
        let resultToSerialize: Result<Data?, URLRequestError> = .failure(.unknown)
        
        // When
        let serializeCodableExpectation = expectation(description: "serializeCodableExpectation")
        var errorThrown: Error?
        sut.serializeCodable(resultToSerialize, responseType: SomeResponse.self) { result in
            do {
                _ = try result.get()
                XCTFail("`success` was not expected.")
            } catch {
                errorThrown = error
            }
            serializeCodableExpectation.fulfill()
        }
        wait(for: [serializeCodableExpectation], timeout: 1.0)

        // Then
        XCTAssertNotNil(errorThrown, "An error, should have been thrown.")
        guard case .urlRequest = errorThrown as? NetworkingError else {
            XCTFail("Invalid error found, expected `URLRequestError.urlRequest`.")
            return
        }
    }
    
}

// MARK: - Testing Helpers

private final class SomeCodableSerializingThing: CodableSerializing {}

struct SomeResponse: Codable, Equatable {
    let value: String
    static func == (lhs: SomeResponse, rhs: SomeResponse) -> Bool {
        return lhs.value == rhs.value
    }
}

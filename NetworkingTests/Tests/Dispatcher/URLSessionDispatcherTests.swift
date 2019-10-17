//
//  URLSessionDispatcherTests.swift
//  NetworkingTests
//
//  Created by Eduardo Sanches Bocato on 30/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import Networking

final class URLSessionDispatcherTests: XCTestCase {
    
    func test_invalidURL_shouldReturnRequestBuildeFailureError() {
        // Given
        let sut = URLSessionDispatcher(requestBuilderType: URLRequestBuilderErrorReturningMock.self)
        guard let url = URL(string: "http://www.someurl.com/") else {
            XCTFail("Could not create URL.")
            return
        }
        let request: SimpleURLRequest = .init(url: url)

        // When
        let executeRequestExpectation = expectation(description: "executeRequestExpectation")
        var errorThrown: Error?
        sut.execute(request: request) { (result) in
            do {
                _ = try result.get()
                XCTFail("`success` was not expected.")
            } catch {
                errorThrown = error
            }
            executeRequestExpectation.fulfill()
        }
        wait(for: [executeRequestExpectation], timeout: 1.0)

        // Then
        XCTAssertNotNil(errorThrown, "An error, should have been thrown.")
        guard case .requestBuilderFailed = errorThrown as? URLRequestError else {
            XCTFail("Invalid error found, expected `URLRequestError.requestBuilderFailed`.")
            return
        }
    }
    
    func test_nilHTTPResponse_shouldReturnInvalidHTTPURLResponseError() {
        // Given
        guard let url = URL(string: "http://www.someurl.com/") else {
            XCTFail("Could not create URL.")
            return
        }
        let urlSessionStub = URLSessionStub(
            data: nil,
            urlResponse: nil
        )
        let sut = URLSessionDispatcher(session: urlSessionStub)
        let request: SimpleURLRequest = .init(url: url)

        // When
        let executeRequestExpectation = expectation(description: "executeRequestExpectation")
        var errorThrown: Error?
        sut.execute(request: request) { (result) in
            do {
                _ = try result.get()
                XCTFail("`success` was not expected.")
            } catch {
                errorThrown = error
            }
            executeRequestExpectation.fulfill()
        }
        wait(for: [executeRequestExpectation], timeout: 1.0)

        // Then
        XCTAssertNotNil(errorThrown, "An error, should have been thrown.")
        guard case .invalidHTTPURLResponse = errorThrown as? URLRequestError else {
            XCTFail("Invalid error found, expected `URLRequestError.invalidHTTPURLResponse`.")
            return
        }
    }
    
    func test_nilData_shouldReturnSuccessWithNilData() {
        // Given
        guard let url = URL(string: "http://www.someurl.com/") else {
            XCTFail("Could not create URL.")
            return
        }
        let urlResponse = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        let urlSessionStub = URLSessionStub(
            data: nil,
            urlResponse: urlResponse
        )
        let sut = URLSessionDispatcher(session: urlSessionStub)
        let request: SimpleURLRequest = .init(url: url)

        // When
        let executeRequestExpectation = expectation(description: "executeRequestExpectation")
        var isDataReturnedNil = false
        sut.execute(request: request) { (result) in
            do {
                let data = try result.get()
                isDataReturnedNil = data == nil
            } catch {
                XCTFail("Did not expected: \(error.localizedDescription).")
            }
            executeRequestExpectation.fulfill()
        }
        wait(for: [executeRequestExpectation], timeout: 1.0)

        // Then
        XCTAssertTrue(isDataReturnedNil, "Expected to receive `nil` data.")
    }
    
    func test_validData_shouldReturnSuccessWithValidData() {
        // Given
        guard let url = URL(string: "http://www.someurl.com/") else {
            XCTFail("Could not create URL.")
            return
        }
        let urlResponse = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        let urlSessionStub = URLSessionStub(
            data: Data(),
            urlResponse: urlResponse
        )
        let sut = URLSessionDispatcher(session: urlSessionStub)
        let request: SimpleURLRequest = .init(url: url)

        // When
        let executeRequestExpectation = expectation(description: "executeRequestExpectation")
        var isDataReturnedValid = false
        sut.execute(request: request) { (result) in
            do {
                let data = try result.get()
                isDataReturnedValid = data != nil
            } catch {
                XCTFail("Did not expected: \(error.localizedDescription).")
            }
            executeRequestExpectation.fulfill()
        }
        wait(for: [executeRequestExpectation], timeout: 1.0)

        // Then
        XCTAssertTrue(isDataReturnedValid, "Expected to receive `nil` data.")
    }
    
    func test_not400not200range_shouldReturnUnknownError() {
        // Given
        guard let url = URL(string: "http://www.someurl.com/") else {
            XCTFail("Could not create URL.")
            return
        }
        let urlResponse = HTTPURLResponse(
            url: url,
            statusCode: 300,
            httpVersion: nil,
            headerFields: nil
        )
        let urlSessionStub = URLSessionStub(
            data: nil,
            urlResponse: urlResponse,
            error: NSError()
        )
        let sut = URLSessionDispatcher(session: urlSessionStub)
        let request: SimpleURLRequest = .init(url: url)

        // When
        let executeRequestExpectation = expectation(description: "executeRequestExpectation")
        var errorThrown: Error?
        sut.execute(request: request) { (result) in
            do {
                _ = try result.get()
                XCTFail("`success` was not expected.")
            } catch {
                errorThrown = error
            }
            executeRequestExpectation.fulfill()
        }
        wait(for: [executeRequestExpectation], timeout: 1.0)

        // Then
        XCTAssertNotNil(errorThrown, "An error, should have been thrown.")
        guard case .unknown = errorThrown as? URLRequestError else {
            XCTFail("Invalid error found, expected `URLRequestError.unknown`.")
            return
        }
    }
    
    func test_400withData_shouldReturnErrorWithData() {
        // Given
        guard let url = URL(string: "http://www.someurl.com/") else {
            XCTFail("Could not create URL.")
            return
        }
        let urlResponse = HTTPURLResponse(
            url: url,
            statusCode: 400,
            httpVersion: nil,
            headerFields: nil
        )
        let urlSessionStub = URLSessionStub(
            data: Data(),
            urlResponse: urlResponse,
            error: nil
        )
        let sut = URLSessionDispatcher(session: urlSessionStub)
        let request: SimpleURLRequest = .init(url: url)

        // When
        let executeRequestExpectation = expectation(description: "executeRequestExpectation")
        var errorThrown: Error?
        sut.execute(request: request) { (result) in
            do {
                _ = try result.get()
                XCTFail("`success` was not expected.")
            } catch {
                errorThrown = error
            }
            executeRequestExpectation.fulfill()
        }
        wait(for: [executeRequestExpectation], timeout: 1.0)

        // Then
        XCTAssertNotNil(errorThrown, "An error, should have been thrown.")
        guard case .withData = errorThrown as? URLRequestError else {
            XCTFail("Invalid error found, expected `URLRequestError.withData`.")
            return
        }
    }
    
    func test_400withNoData_shouldReturnErrorWithData() {
        // Given
        guard let url = URL(string: "http://www.someurl.com/") else {
            XCTFail("Could not create URL.")
            return
        }
        let urlResponse = HTTPURLResponse(
            url: url,
            statusCode: 400,
            httpVersion: nil,
            headerFields: nil
        )
        let urlSessionStub = URLSessionStub(
            data: nil,
            urlResponse: urlResponse,
            error: nil
        )
        let sut = URLSessionDispatcher(session: urlSessionStub)
        let request: SimpleURLRequest = .init(url: url)

        // When
        let executeRequestExpectation = expectation(description: "executeRequestExpectation")
        var errorThrown: Error?
        sut.execute(request: request) { (result) in
            do {
                _ = try result.get()
                XCTFail("`success` was not expected.")
            } catch {
                errorThrown = error
            }
            executeRequestExpectation.fulfill()
        }
        wait(for: [executeRequestExpectation], timeout: 1.0)

        // Then
        XCTAssertNotNil(errorThrown, "An error, should have been thrown.")
        guard case .unknown = errorThrown as? URLRequestError else {
            XCTFail("Invalid error found, expected `URLRequestError.unknown`.")
            return
        }
    }
    
}

// MARK: - Testing Helpers

private final class URLRequestBuilderErrorReturningMock: URLRequestBuilder {
    
    init(request: URLRequestProtocol) {}
    init(with baseURL: URL, path: String?) {}
    func set(method: HTTPMethod) -> Self { return self }
    func set(path: String) -> Self { return self }
    func set(headers: [String : String]?) -> Self { return self }
    func set(parameters: URLRequestParameters?) -> Self { return self }
    func add(adapter: URLRequestAdapter) -> Self { return self }
    
    func build() throws -> URLRequest {
        throw NSError()
    }
    
}

final class URLSessionDataTaskDummy: URLSessionDataTaskProtocol {
    func resume() {}
    func cancel() {}
}

final class URLSessionStub: URLSessionProtocol {
    
    private let dataToReturn: Data?
    private let urlResponseToReturn: URLResponse?
    private let errorToReturn: Error?
    private let dataTaskToReturn: URLSessionDataTaskProtocol
    init(
        data: Data? = nil,
        urlResponse: URLResponse?,
        error: Error? = nil,
        dataTask: URLSessionDataTaskProtocol = URLSessionDataTaskDummy()
    ) {
        self.dataToReturn = data
        self.urlResponseToReturn = urlResponse
        self.errorToReturn = error
        self.dataTaskToReturn = dataTask
    }
    
    func dataTask(with request: NSURLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        completionHandler(dataToReturn, urlResponseToReturn, errorToReturn)
        return dataTaskToReturn
    }
    
}

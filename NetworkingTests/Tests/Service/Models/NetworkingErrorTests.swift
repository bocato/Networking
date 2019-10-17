//
//  NetworkingErrorTests.swift
//  NetworkingTests
//
//  Created by Eduardo Sanches Bocato on 02/10/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import Networking

final class NetworkingErrorTests: XCTestCase {
    
    func test_unknown_error() {
        // Given
        let rawError = NSError(domain: "NetworkingError", code: 10, description: "An unknown error has occurred in the service.")
        
        // When
        let sut = NetworkingError.unknown.rawError
        
        // Then
        XCTAssertEqual(rawError, sut, "Expected \(rawError), but got \(sut).")
    }
    
    func test_unexpected_error() {
        // Given
        let rawError = NSError(domain: "NetworkingError", code: 11, description: "An unexpected error has occurred in the service.")
        
        // When
        let sut = NetworkingError.unexpected.rawError
        
        // Then
        XCTAssertEqual(rawError, sut, "Expected \(rawError), but got \(sut).")
    }
    
    func test_urlRequest_errorCode() {
        // Given
        let rawError = NSError(domain: "NetworkingError", code: -1, description: "There was an error in the URLRequest.")
        
        // When
        let urlRequest = URLRequestError.unknown
        let sut = NetworkingError.urlRequest(urlRequest).code
        
        // Then
        XCTAssertEqual(rawError.code, sut, "Expected \(rawError.code), but got \(sut).")
    }
    
    func test_urlRequest_errorLocalizedDescription() {
        // Given
        let rawError = NSError(domain: "NetworkingError", code: -1, description: "There was an error in the URLRequest.")
        
        // When
        let urlRequest = URLRequestError.unknown
        let sut = NetworkingError.urlRequest(urlRequest).localizedDescription
        
        // Then
        XCTAssertEqual(rawError.localizedDescription, sut, "Expected \(rawError.localizedDescription), but got \(sut).")
    }
    
    func test_urlRequest_rawError() {
        // Given
        let rawError = NSError(domain: "URLRequestError", code: -1, description: "Unknown error.")
        
        // When
        let urlRequest = URLRequestError.unknown
        let sut = NetworkingError.urlRequest(urlRequest).rawError
        
        // Then
        XCTAssertEqual(rawError, sut, "Expected \(rawError), but got \(sut).")
    }
    
    func test_serializationError_errorCode() {
        // Given
        let rawError = NSError(domain: "NetworkingError", code: 12, description: "A serialization error has occurred.")
        
        // When
        let sut = NetworkingError.serializationError(rawError).code
        
        // Then
        XCTAssertEqual(rawError.code, sut, "Expected \(rawError.code), but got \(sut).")
    }
    
    func test_serializationError_errorLocalizedDescription() {
        // Given
        let rawError = NSError(domain: "NetworkingError", code: 12, description: "A serialization error has occurred.")
        
        // When
        let sut = NetworkingError.serializationError(rawError).localizedDescription
        
        // Then
        XCTAssertEqual(rawError.localizedDescription, sut, "Expected \(rawError.localizedDescription), but got \(sut).")
    }
    
    func test_serializationError_rawError() {
        // Given
        let rawError = NSError(domain: "NetworkingError", code: 12, description: "A serialization error has occurred.")
        
        // When
        let sut = NetworkingError.serializationError(rawError).rawError
        
        // Then
        XCTAssertEqual(rawError, sut, "Expected \(rawError), but got \(sut).")
    }
    
    func test_noData_error() {
        // Given
        let rawError = NSError(domain: "NetworkingError", code: 13, description: "No data was found.")
        
        // When
        let sut = NetworkingError.noData.rawError
        
        // Then
        XCTAssertEqual(rawError, sut, "Expected \(rawError), but got \(sut).")
    }
    
    func test_invalidURL_error() {
        // Given
        let rawError = NSError(domain: "NetworkingError", code: 14, description: "The URL is invalid.")
        
        // When
        let sut = NetworkingError.invalidURL.rawError
        
        // Then
        XCTAssertEqual(rawError, sut, "Expected \(rawError), but got \(sut).")
    }
    
}

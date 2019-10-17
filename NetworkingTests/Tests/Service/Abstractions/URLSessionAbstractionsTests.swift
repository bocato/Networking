//
//  URLSessionAbstractionsTests.swift
//  NetworkingTests
//
//  Created by Eduardo Sanches Bocato on 02/10/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import Networking

final class URLSessionAbstractionsTests: XCTestCase {
    
    func test_urlSessionDataTaskCalled_shouldReturnURLSessionDataTaskProtocol() {
        // Given
        guard let url = URL(string: "http://www.someurl.com/") else {
            XCTFail("Could not create an URL.")
            return
        }
        let urlRequest = NSURLRequest(url: url)
        
        // When
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
       
        let sut = session.dataTask(with: urlRequest) { (data, response, error) in
            XCTFail("URLSessionDataTaskProtocol was not created.")
        }
        // Then
        XCTAssertNotNil(sut, "Expected a session, but got nil.")
    }
}

private class URLSessionAbstractionsMock: URLSessionProtocol {
    let dataTask: URLSessionDataTaskProtocol = URLSessionDataTaskDummy()
    
    func dataTask(with request: NSURLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask
    }
}

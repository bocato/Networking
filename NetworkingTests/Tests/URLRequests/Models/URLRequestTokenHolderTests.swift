//
//  URLRequestTokenHolderTests.swift
//  NetworkingTests
//
//  Created by Eduardo Sanches Bocato on 30/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import Networking

final class URLRequestTokenHolderTests: XCTestCase {
    
    func test_cancelSouldCancelTask() {
        // Given
        let taskSpy = URLSessionDataTaskSpy()
        let sut = URLRequestTokenHolder(task: taskSpy)
        
        // When
        sut.cancel()
        
        // Then
        XCTAssertTrue(taskSpy.cancelCalled, "`cancel` should have been called on the task.")
    }
    
}

// MARK: - Testing Helpers

final class URLSessionDataTaskSpy: URLSessionDataTaskProtocol {
    
    private(set) var resumeCalled = false
    func resume() {
        resumeCalled = true
    }
    
    private(set) var cancelCalled = false
    func cancel() {
        cancelCalled = true
    }
    
}

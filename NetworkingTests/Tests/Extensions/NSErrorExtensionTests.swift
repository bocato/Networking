//
//  NSErrorExtensionTests.swift
//  NetworkingTests
//
//  Created by Eduardo Sanches Bocato on 20/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

@testable import Networking
import XCTest

final class NSErrorExtensionTests: XCTestCase {
    
    func test_initNSErrorWithDescription() {
        // Given
        let description = "Some description"
        
        // When
        let error = NSError(domain: "NSErrorExtensionTests", code: -1, description: description)
        
        // Then
        XCTAssertEqual(error.localizedDescription, description, "The descriptions are different, when they should be the same.")
    }
    
}

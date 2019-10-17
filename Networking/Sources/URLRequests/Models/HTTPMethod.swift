//
//  HTTPMethod.swift
//  Networking
//
//  Created by Eduardo Sanches Bocato on 19/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

/// This defines the type of HTTP method used to perform the request.
///
/// - get: GET method.
/// - put: PUT method.
/// - post: POST method.
/// - patch: PATCH method.
/// - delete: DELETE method.
public enum HTTPMethod: String {
    
    /// Defines the suported types of HTTP methods.
    case post
    case put
    case get
    case delete
    case patch
    
    /// Returns the name of the method to be used in the request.
    public var name: String {
        return rawValue.uppercased()
    }
    
}

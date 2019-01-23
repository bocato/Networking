//
//  Configuration.swift
//  Networking
//
//  Created by Eduardo Bocato on 04/01/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import Foundation

/// Defines the environment configuration to be extracted
/// from our configution files (normally Plists)
public struct Configuration {
    
    /// Defines the environment name, ie. Production, Staging, Dev and so on
    let name: String
    
    /// Here we can put the default headers that we need for all requests
    let headers: [String: String]
    
    /// The base URL for the dispatcher
    let baseURL: URL
    
    /// Initialzer, that sets the initial values and starts the MASFoundation instance with the givend configurations
    ///
    /// - Parameters:
    ///   - name: the enviroment
    ///   - headers: the default headers for the environment
    public init(name: String, headers: [String: String]? = nil, baseURL: URL) {
        self.name = name
        self.headers = headers ?? [:]
        self.baseURL = baseURL
    }
    
}

//
//  SimpleURLRequest.swift
//  Networking
//
//  Created by Eduardo Sanches Bocato on 19/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

/// Defines a simple request, where the only thin needed is the baseURL and the request type to run a request
public struct SimpleURLRequest: URLRequestProtocol {
    
    public var baseURL: URL
    public var path: String?
    public var method: HTTPMethod
    public var parameters: URLRequestParameters?
    public var headers: [String : String]?
    public var adapters: [URLRequestAdapter]?
    
    public init(url: URL,
         method: HTTPMethod = .get) {
        self.baseURL = url
        self.method = method
    }
    
}

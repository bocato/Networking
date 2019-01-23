//
//  NetworkingError.swift
//  Networking
//
//  Created by Eduardo Bocato on 04/01/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import Foundation

private let domain = "NetworkingError"

/// Model for the networking error returned from the CA
public struct NetworkingError: Error {
    
    public var rawError: Error?
    public var rawErrorString: String?
    public var rawErrorData: Data?
    
    public var response: HTTPURLResponse?
    public var request: Request?
    public var task: URLSessionDataTaskProtocol?
    
    init() {}
    
    init(rawError: Error) {
        self.rawError = rawError
    }
    
    init(rawError: Error?,
         rawErrorString: String?,
         rawErrorData: Data?,
         response: HTTPURLResponse?,
         request: Request?,
         task: URLSessionDataTaskProtocol?) {
        
        self.rawError = rawError
        self.rawErrorString = rawErrorString
        self.rawErrorData = rawErrorData
        self.response = response
        self.request = request
        self.task = task
        
    }
    
    init(rawError: Error?, rawErrorData: Data?, response: HTTPURLResponse?, request: Request?) {
        self.rawError = rawError
        self.rawErrorData = rawErrorData
        self.response = response
        self.request = request
    }
    
    init(internalError: Internal) {
        self.rawError = internalError
    }
    
}
public extension NetworkingError {
    
    /// Internal Networking errors
    enum Internal: Error {
        
        case unknown
        case noData
        case invalidURL
        
        var statusCode: Int {
            switch self {
            case .unknown:
                return -1
            case .noData:
                return -2
            case .invalidURL:
                return -3
            }
        }
        
        var rawError: NSError {
            switch self {
            case .unknown:
                return NSError(domain: domain, code: statusCode, description: "Unknown error.")
            case .noData:
                return NSError(domain: domain, code: statusCode, description: "No data.")
            case .invalidURL:
                return NSError(domain: domain, code: statusCode, description: "Invalid URL.")
            }
        }
        
    }
    
}

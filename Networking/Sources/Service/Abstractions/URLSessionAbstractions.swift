//
//  URLSessionAbstractions.swift
//  Networking
//
//  Created by Eduardo Sanches Bocato on 30/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

/// Defines an abstraction for an URLSession
public protocol URLSessionProtocol {
    func dataTask(with request: NSURLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    public func dataTask(with request: NSURLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let urlRequest = request as URLRequest
        let task = dataTask(with: urlRequest, completionHandler: completionHandler)
        return task as URLSessionDataTaskProtocol
    }
}

/// Defines an abstraction for an URLSessionDataTask
public protocol URLSessionDataTaskProtocol: AnyObject {
    func resume()
    func cancel()
}
extension URLSessionDataTask: URLSessionDataTaskProtocol {}

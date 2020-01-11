//
//  URLRequestDispatcher.swift
//  Networking
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

/// This guy is responsible for executing the requests by calling whoever we want to use as a client to deal with networking.
public protocol URLRequestDispatcher {
    
    /// Defines an adapter to modify requests when needed
    var adapter: URLRequestAdapter? { get set }
    
    /// Executes the request and provides a completion with the response.
    ///
    /// - Parameters:
    ///   - queue: the queue you what to dispatch the requests.
    ///   - request: The request to be executed.
    ///   - completion: The request's callback.
    /// - Returns: A token that allows us manipulate the task if needed.
    @discardableResult
    func execute(on queue: DispatchQueue, request: URLRequestProtocol, completion: @escaping (_ response: Result<Data?, URLRequestError>) -> Void) -> URLRequestToken?
    
    /// Executes the request and provides a completion with the response.
    ///
    /// - Parameters:
    ///   - request: The request to be executed.
    ///   - completion: The request's callback.
    /// - Returns: A token that allows us manipulate the task if needed.
    @discardableResult
    func execute(request: URLRequestProtocol, completion: @escaping (_ response: Result<Data?, URLRequestError>) -> Void) -> URLRequestToken?
}
extension URLRequestDispatcher {
    
    @discardableResult
    public func execute(request: URLRequestProtocol, completion: @escaping (_ response: Result<Data?, URLRequestError>) -> Void) -> URLRequestToken? {
        return execute(on: .main, request: request, completion: completion)
    }
    
}

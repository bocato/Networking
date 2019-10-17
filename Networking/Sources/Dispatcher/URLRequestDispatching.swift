//
//  URLRequestDispatching.swift
//  Networking
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

/// This guy is responsible for executing the requests by calling whoever we want to use as a client to deal with networking.
public protocol URLRequestDispatching {
    
    /// Executes the request and provides a completion with the response.
    ///
    /// - Parameters:
    ///   - request: The request to be executed.
    ///   - completion: The request's callback.
    /// - Returns: A token that allows us manipulate the task if needed.
    @discardableResult
    func execute(request: URLRequestProtocol, completion: @escaping (_ response: Result<Data?, URLRequestError>) -> Void) -> URLRequestToken?
}

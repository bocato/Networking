//
//  NetworkDispatcher.swift
//  Networking
//
//  Created by Eduardo Bocato on 04/01/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import Foundation

/// This guy is responsible for executing the requests
/// by calling whover we want to use as a client to deal
/// with networking...
public protocol NetworkDispatcher {
    
    /// Our dispatchers environment
    var configuration: Configuration { get }
    
    /// Whe must initialialize the Dispatcher with an environment
    ///
    /// - Parameter environment: environment to send or receive data
    init(configuration: Configuration)
    
    /// Executes the request and provides a completion with the response
    ///
    /// - Parameters:
    ///   - request: the request to be executed
    ///   - completion: the requests callback
    func execute(request: Request, completion: @escaping (_ response: Response) -> Void)
}

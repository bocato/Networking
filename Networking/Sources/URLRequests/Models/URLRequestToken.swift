//
//  URLRequestToken.swift
//  Networking
//
//  Created by Eduardo Sanches Bocato on 19/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

/// Task abstraction in order to make the request cancelable without exposing the URLSessionDataTask.
public protocol URLRequestToken {
    func cancel()
}

/// Task abstraction in order to make the request cancelable without exposing the URLSessionDataTask.
final class URLRequestTokenHolder: URLRequestToken {
    
    // MARK: - Properties
    
    private weak var task: URLSessionDataTaskProtocol?
    
    // MARK: - Initialization
    
    /// Initializer
    ///
    /// - Parameter task: An URLSessionDataTask that can be canceled.
    init(task: URLSessionDataTaskProtocol) {
        self.task = task
    }
    
    // MARK: - Functions
    
    /// Cancels the data task.
    public func cancel() {
        task?.cancel()
    }
    
}

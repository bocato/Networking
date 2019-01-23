//
//  Service.swift
//  Networking
//
//  Created by Eduardo Bocato on 04/01/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import Foundation

/// Defines an networking service
public protocol Service {
    
    /// The dispatcher to take care of the network requests
    var dispatcher: NetworkDispatcher { get }
    
    /// Intializer to inject the dispatcher
    ///
    /// - Parameter dispatcher: the dispatcher to take care of the network requests
    init(dispatcher: NetworkDispatcher)
}

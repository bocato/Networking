//
//  Response.swift
//  Networking
//
//  Created by Eduardo Bocato on 04/01/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import Foundation

/// Defines the response received from the HTTP call
///
/// - data: found some data on the
/// - error: an error was found when fetching the HTTP response
public enum Response {
    case data(_: Data?)
    case error(NetworkingError?)
}

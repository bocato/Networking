//
//  URLRequestParameters.swift
//  Networking
//
//  Created by Eduardo Sanches Bocato on 19/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

/// Defines the parameters to pass along with the request.
///
/// - body: Parameters to be embeded on the body of the request.
/// - url: Path parameters to be set on the URL.
public enum URLRequestParameters {
    case body(_: [String: Any]?)
    case url(_: [String: String]?)
}

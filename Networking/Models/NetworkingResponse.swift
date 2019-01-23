//
//  NetworkingResponse.swift
//  Networking
//
//  Created by Eduardo Bocato on 23/01/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import Foundation

struct NetworkingResponse {
    let data: Data?
    let error: Error?
    let httpResponse: HTTPURLResponse?
    let request: Request?
}

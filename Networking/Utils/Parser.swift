//
//  ParserProtocol.swift
//  Networking
//
//  Created by Eduardo Bocato on 23/01/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import Foundation

protocol Parser {
    func parseErrors(in response: NetworkingResponse) -> NetworkingError?
}

class DefaultParser: Parser {
    
    func parseErrors(in response: NetworkingResponse) -> NetworkingError? {
        
        guard let statusCode = response.httpResponse?.statusCode else {
            return NetworkingError(internalError: .unknown)
        }
        
        if !(200...299 ~= statusCode) {
            
            guard response.error == nil else {
                return NetworkingError(internalError: .unknown)
            }
            
            guard 400...499 ~= statusCode, let data = response.data, let jsonString = String(data: data, encoding: .utf8) else {
                return NetworkingError(internalError: .unknown)
            }
            
            return NetworkingError(rawError: response.error, rawErrorData: response.data, response: response.httpResponse, request: response.request)
            
        }
        
        return nil
        
    }
    
}

//
//  CodableRequesting.swift
//  Networking
//
//  Created by Eduardo Sanches Bocato on 19/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

public protocol CodableRequesting: CodableSerializing, NetworkingService {
    
    /// Helper function to request codable responses
    ///
    /// - Parameters:
    ///   - request: the request to be serialized.
    ///   - responseType: The response type (Codable).
    ///   - completion: The serialization completion handler.
    ///   - Returns: A token that allows us manipulate the task if needed.
    @discardableResult
    func requestCodable<ResponseType: Codable>(
        _ request: URLRequestProtocol,
        ofType type: ResponseType.Type,
        completion: @escaping (Result<ResponseType, NetworkingError>) -> Void
    ) -> URLRequestToken?
}
extension CodableRequesting {
    
    @discardableResult
    public func requestCodable<ResponseType: Codable>(
        _ request: URLRequestProtocol,
        ofType type: ResponseType.Type,
        completion: @escaping (Result<ResponseType, NetworkingError>) -> Void
    ) -> URLRequestToken? {
        return dispatcher.execute(request: request) { result in
            self.serializeCodable(result, responseType: type, completion: completion)
        }
    }
    
}

//
//  NetworkingOperation.swift
//  Networking
//
//  Created by Eduardo Bocato on 23/01/19.
//  Copyright © 2019 Eduardo Bocato. All rights reserved.
//

import Foundation

public struct NetworkingOperation<RequestType: Request, ResponseType: Codable> {
    
    ///
    public typealias NetworkingOperationCompletion = (_ response: ResponseType?, _ error: NetworkingError?) -> Void
    
    /// The request to be executed
    let request: RequestType
    
    /// Initialization
    ///
    /// - Parameter request: The request for this operation
    public init(request: RequestType) {
        self.request = request
    }
    
    /// Execute an request operation
    ///
    /// - Parameters:
    ///   - dispatcher: the dispatcher to perform requests
    ///   - completion: the result of the operation
    public func execute(in dispatcher: NetworkDispatcher, completion: @escaping NetworkingOperationCompletion) {
        
        dispatcher.execute(request: request) { (response) in
            switch response {
            case .data(let data):
                
                guard let data = data else {
                    completion(nil, NetworkingError(internalError: .noData))
                    return
                }
                
                do {
                    let serializedResponse = try JSONDecoder().decode(ResponseType.self, from: data)
                    completion(serializedResponse, nil)
                } catch let error {
                    completion(nil, NetworkingError(rawError: error))
                }
                
            case .error(let error): // TODO: Serialize error?
                let networkingError: NetworkingError = error ?? NetworkingError(internalError: .unknown)
                completion(nil, networkingError)
            }
        }
        
    }
    
}

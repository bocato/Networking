//
//  URLSessionDispatcher.swift
//  Networking
//
//  Created by Eduardo Sanches Bocato on 27/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

private struct DataTaskResponse {
    let data: Data?
    let error: Error?
    let httpResponse: HTTPURLResponse
}

public final class URLSessionDispatcher: URLRequestDispatching {
    
    // MARK: - Properties
    
    private var session: URLSessionProtocol
    private var requestBuilderType: URLRequestBuilder.Type
    
    // MARK: - Initialization
    
    /// Initilizes the dispatcher with a session that can be injected.
    ///
    /// - Parameter session: An URLSession.
    public required init(
        session: URLSessionProtocol = URLSession.shared,
        requestBuilderType: URLRequestBuilder.Type = DefaultURLRequestBuilder.self
    ) {
        self.session = session
        self.requestBuilderType = requestBuilderType
    }
    
    // MARK: - Public
    
    @discardableResult
    public func execute(
        request: URLRequestProtocol,
        completion: @escaping (Result<Data?, URLRequestError>) -> Void
    ) -> URLRequestToken? {
        
        var urlRequestToken: URLRequestToken?
        
        do {
            
            let urlRequest = try requestBuilderType
                .init(request: request)
                .build() as NSURLRequest
            
            let dataTask = session.dataTask(with: urlRequest) { [weak self] (data, urlResponse, error) in
                
                guard let httpResponse = urlResponse as? HTTPURLResponse else {
                    completion(.failure(.invalidHTTPURLResponse))
                    return
                }
                
                let dataTaskResponse = DataTaskResponse(
                    data: data,
                    error: error,
                    httpResponse: httpResponse
                )
                
                if let urlRequestError = self?.parseErrors(in: dataTaskResponse) {
                    completion(.failure(urlRequestError))
                } else {
                    guard let data = data else {
                        completion(.success(nil))
                        return
                    }
                    completion(.success(data))
                }
            }
            urlRequestToken = URLRequestTokenHolder(task: dataTask)
            dataTask.resume()
            
        } catch {
            completion(.failure(.requestBuilderFailed))
        }
        
        return urlRequestToken
    }
    // MARK: - Private Functions
    
    private func parseErrors(in dataTaskResponse: DataTaskResponse) -> URLRequestError? {
        
        let statusCode = dataTaskResponse.httpResponse.statusCode
        
        if (200...299 ~= statusCode) == false {
            
            guard dataTaskResponse.error == nil else {
                return .unknown
            }
            
            guard 400...499 ~= statusCode, let data = dataTaskResponse.data, let jsonString = String(data: data, encoding: .utf8) else {
                return .unknown
            }
            
            debugPrint(jsonString)
            return .withData(data, dataTaskResponse.error)
            
        }
        
        return nil
        
    }
    
}

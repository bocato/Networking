//
//  URLRequestBuilder.swift
//  Networking
//
//  Created by Eduardo Sanches Bocato on 19/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

public protocol URLRequestBuilder {
    
    // MARK: - Initialization
    
    /// Intitializes a builder from an URLRequestProtocol
    /// - Parameter request: the URLRequest to init the builder
    init(request: URLRequestProtocol)
    
    /// Initializes the request.
    ///
    /// - Parameters:
    ///   - baseURL: A base URL.
    ///   - path: A path for the request.
    init(with baseURL: URL, path: String?)
    
    // MARK: - Builder methods
    
    /// Sets the method.
    ///
    /// - Parameter method: A HTTPMethod.
    /// - Returns: Itself, for sugar syntax purposes.
    @discardableResult
    func set(method: HTTPMethod) -> Self
    
    /// Sets the request path.
    ///
    /// - Parameter path: A path.
    /// - Returns: Itself, for sugar syntax purposes.
    @discardableResult
    func set(path: String) -> Self
    
    /// Sets the request headers.
    ///
    /// - Parameter headers: the headers
    /// - Returns: Itself, for sugar syntax purposes.
    @discardableResult
    func set(headers: [String: String]?) -> Self
    
    /// Sets the request parameters.
    ///
    /// - Parameter parameters: some parameters
    /// - Returns: Itself, for sugar syntax purposes.
    @discardableResult
    func set(parameters: URLRequestParameters?) -> Self
    
    /// Sets an adapter, Ex: OAuthAdapter.
    ///
    /// - Parameter adapter: An adapter.
    /// - Returns: Itself, for sugar syntax purposes.
    @discardableResult
    func add(adapter: URLRequestAdapter) -> Self
    
    /// Builds an URLRequest as previously defined.
    ///
    /// - Returns: A configured URLRequest.
    func build() throws -> URLRequest
}

final class DefaultURLRequestBuilder: URLRequestBuilder {
    
    // MARK: - Properties
    
    private var baseURL: URL
    private var path: String?
    private var method: HTTPMethod = .get
    private var headers: [String: String]?
    private var parameters: URLRequestParameters?
    private var adapter: URLRequestAdapter?
    
    // MARK: - Initialization
    
    /// Intitializes a builder from an URLRequestProtocol
    /// - Parameter request: the URLRequest to init the builder
    public init(request: URLRequestProtocol) {
        self.baseURL = request.baseURL
        self.path = request.path
        self.method = request.method
        self.headers = request.headers
        self.parameters = request.parameters
    }
    
    /// Initializes the request.
    ///
    /// - Parameters:
    ///   - baseURL: A base URL.
    ///   - path: A path for the request.
    public init(with baseURL: URL,
                path: String? = nil) {
        self.baseURL = baseURL
        self.path = path
    }
    
    // MARK: - Builder methods
    
    /// Sets the method.
    ///
    /// - Parameter method: A HTTPMethod.
    /// - Returns: Itself, for sugar syntax purposes.
    @discardableResult
    public func set(method: HTTPMethod) -> Self {
        self.method = method
        return self
    }
    
    /// Sets the request path.
    ///
    /// - Parameter path: A path.
    /// - Returns: Itself, for sugar syntax purposes.
    @discardableResult
    public func set(path: String) -> Self {
        self.path = path
        return self
    }
    
    /// Sets the request headers.
    ///
    /// - Parameter headers: the headers
    /// - Returns: Itself, for sugar syntax purposes.
    @discardableResult
    public func set(headers: [String: String]?) -> Self {
        self.headers = headers
        return self
    }
    
    /// Sets the request parameters.
    ///
    /// - Parameter parameters: some parameters
    /// - Returns: Itself, for sugar syntax purposes.
    @discardableResult
    public func set(parameters: URLRequestParameters?) -> Self {
        self.parameters = parameters
        return self
    }
    
    /// Sets an adapter, Ex: OAuthAdapter.
    ///
    /// - Parameter adapter: An adapter.
    /// - Returns: Itself, for sugar syntax purposes.
    @discardableResult
    public func add(adapter: URLRequestAdapter) -> Self {
        self.adapter = adapter
        return self
    }
    
    /// Builds an URLRequest as previously defined.
    ///
    /// - Returns: A configured URLRequest.
    public func build() throws -> URLRequest {
        
        var url = baseURL
        if let path = path {
            url = baseURL.appendingPathComponent(path)
        }
        
        var urlRequest = URLRequest(url: url,
                                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                    timeoutInterval: 100)
        
        urlRequest.httpMethod = method.name
        setupRequest(&urlRequest, with: parameters)
        
        headers?.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        if let adapter = adapter {
            urlRequest = try adapter.adapt(urlRequest)
        }
        
        return urlRequest
    }
    
    // MARK: - Private Functions
    
    private func setupRequest(_ request: inout URLRequest, with parameters: URLRequestParameters?) {
        if let parameters = parameters {
            switch parameters {
            case .body(let bodyParameters):
                configureBodyParameters(bodyParameters, for: &request)
            case .url(let urlParameters):
                configureURLParameters(urlParameters, for: &request)
            }
        }
    }
    
    private func configureBodyParameters(_ parameters: [String: Any]?, for request: inout URLRequest) {
        if let bodyParameters = parameters,
            let payload = try? JSONSerialization.data(withJSONObject: bodyParameters, options: []) {
            request.httpBody = payload
        }
    }
    
    private func configureURLParameters(_ parameters: [String: String]?, for request: inout URLRequest) {
        if let urlParameters = parameters,
            let url = request.url,
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            urlComponents.queryItems = urlParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            request.url = urlComponents.url
        }
    }
    
}

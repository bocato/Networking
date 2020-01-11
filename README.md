# Networking 
[![codecov](https://codecov.io/gh/bocato/Networking/branch/master/graph/badge.svg)](https://codecov.io/gh/bocato/Networking)
[![CodeFactor](https://www.codefactor.io/repository/github/bocato/networking/badge)](https://www.codefactor.io/repository/github/bocato/networking)

Networking layer abstraction

## Instalation

Add this to Cartfile:

`git "https://github.com/bocato/Networking.git" ~> 1.1`

Then:

`$ carthage update`

## Setup

- Use as an abstraction and implement your own dispatcher or use the provided `URLSessionDispatcher`.

## Requests

```swift
enum PokemonsRequest: Request {
    
    case list(limit: Int?)
    
    var path: String {
        switch self {
        case .list:
            return "pokemon"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var parameters: RequestParameters? {
        switch self {
        case .list(let limit):
            guard let limit = limit else { return nil }
            return .url(["limit": limit])
        }
    }
    
}
```


## Service

### Requesting Data

```swift
final class PokemonsDataService: NetworkingService  {
    
    // MARK: - Properties
    
    var dispatcher: URLRequestDispatcher
    
    // MARK: - Initialization
    
    init(dispatcher: URLRequestDispatcher) {
        self.dispatcher = dispatcher
    }
    
    // MARK: - Requests
    
    func getList(completion: @escaping (Result<Data, Error>) -> Void) {
        
        let request: PokemonsRequest = .list
        
        dispatcher.execute(request: request) { (result) in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case .success(data):
                guard let data = data else {
                    completion(.failure(NSError()))
                    return
                }
                completion(data)
            }
        }
        
    }
    
}
```

### Requesting Codable Objects

```swift
final class PokemonsDataService: CodableRequesting  {
    
    // MARK: - Properties
    
    var dispatcher: URLRequestDispatching
    
    // MARK: - Initialization
    
    init(dispatcher: URLRequestDispatching) {
        self.dispatcher = dispatcher
    }
    
    // MARK: - Requests
    
    func getList(completion: @escaping (Result<[Pokemon], NetworkingError>) -> Void) {
        
        let request: PokemonsRequest = .list
        
        requestCodable(request, ofType: [Pokemon].self) { (networkingResult) in
            switch networkingResult {
            case let .failure(error):
                completion(.failure(error))
            case .success(data):
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }
                completion(data)
            }
        }
        
    }
    
}
```

#### URLRequestAdapter

The `URLRequestAdapter` protocol allows each request that conforms with `URLRequestProtocol` request made on a `URLRequestDispatcher` to be inspected and adapted before being created. 
One very specific way to use an adapter is to append an `Authorization` header to requests behind a certain type of authentication.

```swift
final class AccessTokenAdapter: URLRequestAdapter {
    private let accessToken: String

    init(accessToken: String) {
        self.accessToken = accessToken
    }

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest

        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix("https://httpbin.org") {
            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        }

        return urlRequest
    }
}
```

```swift
let dispatcher = URLSessionDispatcher()
dispatcher.adapter = AccessTokenAdapter(accessToken: "1234")

let request: PokemonsRequest = .list
dispatcher.execute(request: request) { (result) in
    switch result {
    case let .failure(error):
        // Do something
    case .success(data):
        // Do something
    }
}
```

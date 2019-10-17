# Networking
Networking layer abstraction

## Setup

- Use as an abstraction and implement your own dispatcher or use the provided `URLSessionDispatcher` dispatcher,

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
    
    var dispatcher: URLRequestDispatching
    
    // MARK: - Initialization
    
    init(dispatcher: URLRequestDispatching) {
        self.dispatcher = dispatcher
    }
    
    // MARK: - ArtistLookupServiceProvider
    
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
    
    // MARK: - ArtistLookupServiceProvider
    
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

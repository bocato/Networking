# Networking
Networking layer abstraction

******************************************
* DISCLAIMER: This is not finished yet.  
******************************************


## Setup

```swift
let baseURL = URL(string: "https://something.com")!
let configuration = Configuration(name: "SomeConfig", headers: nil, baseURL: baseURL)
let dispatcher = URLSessionDispatcher(configuration: configuration)
let service = PokemonService(dispatcher: dispatcher)
```

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


```swift
struct Pokemon: Codable {
    let name: String
}

class PokemonService: Service {
    
    private(set) var dispatcher: NetworkDispatcher
    
    required init(dispatcher: NetworkDispatcher) {
        self.dispatcher = dispatcher
    }
    
    func loadPokemonsList(completion: @escaping (_ response: [Pokemon]?, _ error: NetworkingError?) -> Void) {
        
        let request: PokemonsRequest = .list(limit: 50)
        let operation = NetworkingOperation<PokemonsRequest, [Pokemon]>(request: request)
        
        operation.execute(in: dispatcher) { (result, networkingError) in
            
            guard networkingError == nil else {
                completion(nil, networkingError)
                return
            }
            
            completion(result, nil)
            
        }
        
    }
    
}


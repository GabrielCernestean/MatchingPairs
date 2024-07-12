import Foundation

public class Request {
    
    // MARK: - Properties -
    
    var endpoint: APIEndpoint
    
    // MARK: - Lifecycle -
    
    public init(_ endpoint: APIEndpoint) {
        self.endpoint = endpoint
    }
    
    // MARK: - Public methods -
    
    public func request(_ completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        DispatchQueue.global(qos: .default).async {
            guard let url = URL(string: self.endpoint.url) else {
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    guard error == nil else {
                        completionHandler(.failure(.networkError))
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse else {
                        completionHandler(.failure(.generalError))
                        return
                    }
                    
                    if response.statusCode > 200 {
                        completionHandler(.failure(.networkError))
                        return
                    }
                    
                    if let receivedData = data {
                        completionHandler(.success(receivedData))
                    } else {
                        completionHandler(.failure(.dataError))
                    }
                }
            }
            
            task.resume()
        }
    }
    
}

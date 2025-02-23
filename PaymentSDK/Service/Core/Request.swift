// MARK: - Protocol
protocol Request: Encodable {
    var host: Host { get }
    var method: HTTPMethod { get }
    var endpoint: Endpoint { get }
}

// MARK: - Create URLRequest
extension Request {
    func createURLRequest(apiKey: String? = nil) throws -> URLRequest {
        guard var url = host.url else {
            throw URLError(.badURL)
        }
        
        url.append(component: endpoint.rawValue)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = try JSONEncoder().encode(self)
        
        if let apiKey = apiKey {
            urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return urlRequest
    }
}

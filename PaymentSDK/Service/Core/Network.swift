import Foundation

// MARK: - Protocol
protocol Network {
    func perform<T: Decodable>(
        request: Request,
        apiKey: String
    ) async throws -> T
}

// MARK: - Class
final class DefaultNetwork: Network {
    // MARK: - Protocol Implementation
    func perform<T: Decodable>(
        request: Request,
        apiKey: String
    ) async throws -> T {
        let decoder = JSONDecoder()
        
        // Mock
        guard request.host != .mock else {
            if Bool.random() {
                throw URLError(.badServerResponse)
            } else {
                let mockData = """
                {
                    "status": "success", 
                    "transactionId": "abc123"
                }
                """.data(using: .utf8)!
                return try decoder.decode(T.self, from: mockData)
            }
        }
        
        // Prepare URLRequest and URLSession
        let (data, response) = try await URLSession.shared.data(
            for: request.createURLRequest(apiKey: apiKey)
        )

        // Ensure the response is valid HTTP response with status code 200-299
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        // Decode the response into the given type
        return try decoder.decode(T.self, from: data)
    }
}

import Foundation

// MARK: - Protocol
protocol Network {
    func perform<T: Decodable>(request: Request) async throws -> T
}

// MARK: - Class
final class DefaultNetwork: Network {
    // MARK: - Variables
    private let keychainStorage: KeychainStorage
    
    // MARK: - Lifecycle
    init(keychainStorage: KeychainStorage = DefaultKeychainStorage()) {
        self.keychainStorage = keychainStorage
    }
    
    // MARK: - Protocol Implementation
    func perform<T: Decodable>(request: Request) async throws -> T {
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

        do {
            // Send request
            let (data, response) = try await URLSession.shared.data(
                for: request.createURLRequest(
                    apiKey: keychainStorage.loadAPIKey()
                )
            )

            // Check HTTP Response
            guard let httpResponse = response as? HTTPURLResponse else {
                throw PaymentError.invalidResponse(nil)
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw PaymentError.serverError(statusCode: httpResponse.statusCode)
            }

            // JSON decoding
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw PaymentError.invalidResponse(error)
            }
        } catch let error as URLError {
            throw PaymentError.networkError(error)
        } catch {
            throw PaymentError.unknown
        }
    }
}

@testable import PaymentSDK

class MockNetwork: Network {
    func perform<T>(request: Request) async throws -> T where T : Decodable {
        let mockData = """
        {
            "status": "success", 
            "transactionId": "abc123"
        }
        """.data(using: .utf8)!
        return try JSONDecoder().decode(T.self, from: mockData)
    }
}

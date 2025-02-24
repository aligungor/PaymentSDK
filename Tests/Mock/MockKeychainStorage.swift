@testable import PaymentSDK

class MockKeychainStorage: KeychainStorage {
    var apiKey: String?
    
    func saveAPIKey(_ apiKey: String) {
        self.apiKey = apiKey
    }
    
    func loadAPIKey() -> String? {
        return apiKey
    }
    
    func deleteAPIKey() {
        apiKey = nil
    }
}

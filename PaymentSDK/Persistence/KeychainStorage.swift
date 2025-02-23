import Security

// MARK: - Protocol
protocol KeychainStorage {
    func saveAPIKey(_ apiKey: String)
    func loadAPIKey() -> String?
    func deleteAPIKey()
}

// MARK: - Class
final class DefaultKeychainStorage: KeychainStorage {
    // MARK: - Constants
    private enum Constants {
        static let service = "com.aligungor.paymentSDK"
        static let apiKey = "apiKey"
    }

    // MARK: - Protocol Implementation
    /// Saves or updates the API Key securely in Keychain.
    func saveAPIKey(_ apiKey: String) {
        let data = Data(apiKey.utf8)
        var query = createQuery()

        // First, try to update the existing API Key
        let update: [String: Any] = [kSecValueData as String: data]
        let status = SecItemUpdate(query as CFDictionary, update as CFDictionary)

        // If update fails (meaning key doesn't exist), add a new entry
        if status == errSecItemNotFound {
            query[kSecValueData as String] = data
            SecItemAdd(query as CFDictionary, nil)
        }
    }

    /// Loads the API Key from Keychain.
    func loadAPIKey() -> String? {
        var query = createQuery()
        query[kSecReturnData as String] = kCFBooleanTrue!
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess, let data = result as? Data else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    /// Deletes the API Key from Keychain.
    func deleteAPIKey() {
        let query = createQuery()
        SecItemDelete(query as CFDictionary)
    }

    // MARK: - Private Helper
    /// Creates a Keychain query dictionary for the API Key.
    private func createQuery() -> [String: Any] {
        return [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: Constants.service,
            kSecAttrAccount as String: Constants.apiKey
        ]
    }
}

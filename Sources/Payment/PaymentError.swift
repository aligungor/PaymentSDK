import Foundation

// MARK: - Enum
public enum PaymentError: Error {
    case missingAPIKey
    case requestFailed
    case invalidResponse(Error?)
    case networkError(Error)
    case serverError(statusCode: Int)
    case unknown
}

// MARK: - Localized Error Implementation
extension PaymentError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .requestFailed:
            return "The payment request failed. Please try again."
        case .missingAPIKey:
            return "Missing API key. Please set your API key before making a request."
        case .invalidResponse(let error):
            if let error = error {
                return "The server response was invalid. Details: \(error.localizedDescription)"
            } else {
                return "The server response was invalid."
            }
        case .networkError(let error):
            return "A network error occurred: \(error.localizedDescription). Please check your connection."
        case .serverError(let statusCode):
            return "Server error occurred with status code \(statusCode). Please try again later."
        case .unknown:
            return "An unknown error occurred. Please contact support."
        }
    }
}

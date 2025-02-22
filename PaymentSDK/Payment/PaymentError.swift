// MARK: - Enum
public enum PaymentError: Error {
    case requestFailed
    case invalidResponse
    case networkError(Error)
    case timeout
    case authenticationFailed
    case insufficientFunds
    case serverError(statusCode: Int)
    case unknown
}

// MARK: - Localized Error Implementation
extension PaymentError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .requestFailed:
            return "The payment request failed. Please try again."
        case .invalidResponse:
            return "The server response was invalid."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .timeout:
            return "The payment request timed out."
        case .authenticationFailed:
            return "Authentication failed. Please check your credentials."
        case .insufficientFunds:
            return "Insufficient funds in your account."
        case .serverError(let statusCode):
            return "Server returned an error with status code \(statusCode)."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

import Foundation

// MARK: - Enum
/// Represents the possible statuses of a payment transaction.
public enum PaymentStatus: String {
    /// The payment was processed successfully.
    case success
}

// MARK: - Decodable
/// Allows `PaymentStatus` to be decoded from JSON responses.
extension PaymentStatus: Decodable {}

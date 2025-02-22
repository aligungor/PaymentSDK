// MARK: - Typealiases
/// A unique identifier for a payment transaction.
public typealias TransactionId = String

// MARK: - Struct
/// Represents the response received from the payment API.
public struct PaymentResponse {
    
    // MARK: - Variables
    /// The status of the payment.
    public let status: PaymentStatus
    
    /// A unique identifier for tracking the transaction.
    public let transactionId: TransactionId
    
    // MARK: - Lifecycle
    /// Initializes a new `PaymentResponse` instance.
    /// - Parameters:
    ///   - status: The status of the payment.
    ///   - transactionId: The unique identifier of the transaction.
    init(status: PaymentStatus, transactionId: TransactionId) {
        self.status = status
        self.transactionId = transactionId
    }
}

// MARK: - Decodable
/// Allows `PaymentResponse` to be decoded from JSON.
extension PaymentResponse: Decodable {}

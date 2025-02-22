/// A configuration model for payment transactions.
///
/// This struct holds the necessary parameters to configure a payment request,
/// including amount, currency, recipient, and optional retry settings.
public struct PaymentConfig {
    
    /// The amount of the payment transaction.
    public let amount: Decimal
    
    /// The currency of the payment (e.g., "USD", "EUR").
    public let currency: String
    
    /// The recipient identifier (e.g., user ID or account number).
    public let recipient: String
    
    /// The number of times the payment should be retried in case of failure.
    /// - Default: `0` (No retry)
    public let retryCount: Int

    /// Initializes a new `PaymentConfig` instance.
    ///
    /// - Parameters:
    ///   - amount: The amount of the transaction.
    ///   - currency: The currency of the transaction (e.g., "USD").
    ///   - recipient: The recipient identifier.
    ///   - retryCount: The number of retry attempts in case of failure (default: 0).
    public init(amount: Decimal, currency: String, recipient: String, retryCount: Int = 0) {
        self.amount = amount
        self.currency = currency
        self.recipient = recipient
        self.retryCount = retryCount
    }
}

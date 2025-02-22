// MARK: - Protocol
protocol PaymentService {
    func makePayment(request: PaymentRequest) async throws -> PaymentResponse
}

// MARK: - Class
final class DefaultPaymentService: PaymentService {
    // MARK: Variables
    private let apiKey: String
    private let network: Network
    private let logger: PaymentLogger
    
    // MARK: Lifecycle
    init(
        apiKey: String,
        network: Network = DefaultNetwork(),
        logger: PaymentLogger = DefaultPaymentLogger()
    ) {
        self.apiKey = apiKey
        self.network = network
        self.logger = logger
    }
    
    // MARK: Protocol Implementation
    func makePayment(request: PaymentRequest) async throws -> PaymentResponse {
        logger.log(.info, "💸 Starting payment request with amount: \(request.amount)")
        do {
            let response: PaymentResponse = try await network.perform(
                request: request,
                apiKey: apiKey
            )
            logger.log(.info, "✅ Payment request succeeded with response: \(response)")
            return response
        } catch {
            logger.log(.error, "❌ Payment request failed with error: \(error.localizedDescription)")
            throw error
        }
    }
}

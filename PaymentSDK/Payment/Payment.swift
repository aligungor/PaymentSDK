import Combine

// MARK: - Typealiases

/// A typealias representing the result of a payment operation.
/// It contains a `PaymentResponse` on success or an `Error` on failure.
public typealias PaymentResult = Result<PaymentResponse, Error>

/// A completion handler type used for payment operations.
/// - Parameter result: The result of the payment operation, containing either a successful response or an error.
public typealias PaymentCompletion = (PaymentResult) -> Void

// MARK: - Class

/// Handles payment transactions using different asynchronous strategies.
///
/// The `Payment` class provides methods to process payments via
/// completion handlers, async/await, and Combine.
/// It interacts with a `PaymentService` to handle payment processing.
final public class Payment {
    // MARK: - Variables
    private let apiKey: String
    private let service: PaymentService
    private let logger: PaymentLogger

    // MARK: - Lifecycle
    /// Initializes a `Payment` instance with the default payment service and logger.
    /// - Parameter apiKey: The API key required for authentication.
    public init(apiKey: String) {
        self.apiKey = apiKey
        self.service = DefaultPaymentService(apiKey: apiKey)
        self.logger = DefaultPaymentLogger()
    }

    /// Initializes a `Payment` instance with a custom `PaymentService` and `PaymentLogger`.
    /// - Parameters:
    ///   - apiKey: The API key required for authentication.
    ///   - paymentService: The payment service to process payment requests.
    ///   - logger: The logger used to capture payment process details.
    init(apiKey: String, paymentService: PaymentService, logger: PaymentLogger) {
        self.apiKey = apiKey
        self.service = paymentService
        self.logger = logger
    }

    // MARK: - Public

    /// Initiates a payment request asynchronously using `async/await`.
    ///
    /// - Parameter config: The payment configuration containing settings such as retry count.
    /// - Returns: A `PaymentResponse` if the payment is successful.
    /// - Throws: An error if the payment fails after all retry attempts.
    ///
    /// - Example:
    /// ```swift
    /// let response = try await payment.make(config: myConfig)
    /// ```
    public func make(config: PaymentConfig) async throws -> PaymentResponse {
        logger.log(.info, "💸 Payment process started for amount: \(config.amount)")
        
        let request = PaymentRequest(config: config)
        var lastError: Error?
        let totalAttempts = max(1, config.retryCount + 1) // First try + needed retries
        
        for attempt in 1...totalAttempts {
            do {
                let response = try await self.service.makePayment(request: request)
                logger.log(.info, "✅ Payment successful on attempt \(attempt): \(response)")
                return response
            } catch let error {
                lastError = error
                let remainingAttempts = totalAttempts - attempt
                logger.log(.info, "🔄 Payment failed on attempt \(attempt). Remaining attempts: \(remainingAttempts). Error: \(error.localizedDescription)")
            }
            
            if attempt < totalAttempts {
                try await Task.sleep(nanoseconds: 1_000_000_000)
            }
        }

        logger.log(.error, "❌ Payment failed after \(totalAttempts) attempts with error: \(lastError?.localizedDescription ?? "Unknown error")")
        throw lastError ?? PaymentError.requestFailed
    }
    
    /// Initiates a payment request using a completion handler.
    ///
    /// - Parameters:
    ///   - config: The payment configuration containing settings such as retry count.
    ///   - completion: A closure that is called with the result of the payment operation.
    ///
    /// - Note: This method runs in a background task and does not guarantee execution on the main thread.
    ///
    /// - Example:
    /// ```swift
    /// let payment = Payment()
    /// payment.make(config: myConfig) { result in
    ///     switch result {
    ///     case .success(let response):
    ///         print("Payment successful: \(response)")
    ///     case .failure(let error):
    ///         print("Payment failed: \(error.localizedDescription)")
    ///     }
    /// }
    /// ```
    public func make(config: PaymentConfig, completion: @escaping PaymentCompletion) {
        Task {
            do {
                let response = try await self.make(config: config)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    /// Initiates a payment request using Combine, returning a `Publisher`.
    ///
    /// - Parameter config: The payment configuration containing settings such as retry count.
    /// - Returns: A publisher that emits a `PaymentResponse` on success or an `Error` on failure.
    ///
    /// - Example:
    /// ```swift
    /// let cancellable = payment.make(config: myConfig)
    ///     .sink(receiveCompletion: { completion in
    ///         switch completion {
    ///         case .finished:
    ///             print("Payment successful.")
    ///         case .failure(let error):
    ///             print("Payment failed: \(error)")
    ///         }
    ///     }, receiveValue: { response in
    ///         print("Payment response: \(response)")
    ///     })
    /// ```
    public func make(config: PaymentConfig) -> AnyPublisher<PaymentResponse, Error> {
        return Future { promise in
            Task { [weak self] in
                guard let self else { return }
                do {
                    let response = try await self.make(config: config)
                    promise(.success(response))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

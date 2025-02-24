import XCTest
@testable import PaymentSDK

// MARK: - Class
final class PaymentServiceTests: XCTestCase {
    // MARK: - Variables
    private var paymentService: PaymentService!
    
    // MARK: - Lifecycle
    override func setUpWithError() throws {
        paymentService = DefaultPaymentService(
            network: MockNetwork(),
            logger: MockPaymentLogger()
        )
    }

    // MARK: - Tests
    func testMakePayment() async throws {
        // Given
        let config = PaymentConfig(amount: 1, currency: "USD", recipient: "12342")
        let request = PaymentRequest(config: config)
        
        // When
        let response = try await paymentService.makePayment(request: request)
        
        // Then
        XCTAssertEqual(response.status, .success)
        XCTAssertEqual(response.transactionId, "abc123")
    }
}

import XCTest
import Combine
@testable import PaymentSDK

// MARK: - Class
final class PaymentTests: XCTestCase {
    // MARK: - Variables
    private var payment: Payment!
    private var service: MockPaymentService!
    private var logger: MockPaymentLogger!
    private var keychainStorage: MockKeychainStorage!
    private var cancellables: Set<AnyCancellable> = []
    private let mockConfig = PaymentConfig(
        amount: 10,
        currency: "USD",
        recipient: "recipent"
    )
    private let mockPaymentResponse = PaymentResponse(
        status: .success,
        transactionId: "12345"
    )
    
    // MARK: - Lifecycle
    override func setUpWithError() throws {
        service = MockPaymentService()
        keychainStorage = MockKeychainStorage()
        logger = MockPaymentLogger()
        payment = Payment(
            apiKey: "test",
            paymentService: service,
            logger: logger,
            keychainStorage: keychainStorage
        )
    }

    override func tearDownWithError() throws {
        keychainStorage.deleteAPIKey()
    }

    // MARK: - Tests
    func testPaymentSwiftConcurrency() async throws {
        // Given
        service.mockPaymentResponse = mockPaymentResponse
        
        // When
        let response = try await payment.make(config: mockConfig)
        
        // Then
        XCTAssertEqual(response.status, .success)
        XCTAssertEqual(response.transactionId, "12345")
    }
    
    func testPaymentReceiveErrorWhenPaymentFailed() async throws {
        // Given
        let expectation = XCTestExpectation(description: "Payment failed")
        service.shouldFail = true
        service.mockPaymentResponse = mockPaymentResponse
        
        // When
        do {
            let _ = try await payment.make(config: mockConfig)
        } catch {
            expectation.fulfill()
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    func testPaymentRetryWhenErrorReceived() async throws {
        // Given
        let expectation = XCTestExpectation(description: "Payment failed and then succeeded")
        service.shouldFail = true
        service.mockPaymentResponse = mockPaymentResponse
        let paymentConfig = PaymentConfig(
            amount: 20,
            currency: "USD",
            recipient: "1234",
            retryCount: 1
        )
        
        // When
        do {
            let _ = try await payment.make(config: paymentConfig)
            expectation.fulfill()
        } catch {
            expectation.fulfill()
            service.shouldFail = false
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    func testPaymentCombine() throws {
        // Given
        let expectation = XCTestExpectation(description: "Payment response received")
        service.mockPaymentResponse = mockPaymentResponse
        
        // When
        payment
            .make(config: mockConfig)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { response in
                    XCTAssertEqual(response.status, .success)
                    XCTAssertEqual(response.transactionId, "12345")
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testPaymentCallback() throws {
        // Given
        let expectation = XCTestExpectation(description: "Payment response received")
        service.mockPaymentResponse = mockPaymentResponse
        
        
        // When
        payment
            .make(
                config: mockConfig,
                completion: { result in
                    guard case .success(let response) = result else {
                        XCTFail()
                        return
                    }
                    
                    XCTAssertEqual(response.status, .success)
                    XCTAssertEqual(response.transactionId, "12345")
                    expectation.fulfill()
                }
            )
        
        // Then
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testClearAPIKey() throws {
        // Given
        payment = Payment(
            apiKey: "123",
            paymentService: service,
            logger: logger,
            keychainStorage: keychainStorage
        )
        
        // When
        payment.clearAPIKey()
        
        // Then
        XCTAssertNil(keychainStorage.loadAPIKey())
    }
}

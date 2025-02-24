@testable import PaymentSDK

enum MockError: Error {
    case failedToFetchRates
}

class MockPaymentService: PaymentService {
    var shouldFail: Bool = false
    var mockPaymentResponse: PaymentResponse!
    
    func makePayment(request: PaymentRequest) async throws -> PaymentResponse {
        if shouldFail {
            throw MockError.failedToFetchRates
        }
        return mockPaymentResponse
    }
}

@testable import PaymentSDK

class MockPaymentLogger: PaymentLogger {
    func log(_ level: PaymentSDK.LogLevel, _ message: String) { }
}

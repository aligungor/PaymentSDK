import os

// MARK: - Protocol
protocol PaymentLogger {
    /// Logs a message with the specified log level.
    ///
    /// - Parameters:
    ///   - level: The severity level of the log (info, error, or debug).
    ///   - message: The log message to be recorded.
    func log(_ level: LogLevel, _ message: String)
}

// MARK: - Default Implementation
final class DefaultPaymentLogger: PaymentLogger {
    private let logger: Logger

    init(logger: Logger = Logger(subsystem: "com.aligungor.PaymentSDK", category: "Payment")) {
        self.logger = logger
    }

    /// Logs a message with an appropriate privacy level based on its severity.
    ///
    /// - `.info` logs are **public**, meaning they are visible to both SDK users and system logs.
    /// - `.error` logs are **private**, meaning their content is hidden from SDK users but still accessible to developers.
    /// - `.debug` logs are also **private**, ensuring that debug details are not exposed in public logs.
    ///
    /// This ensures that sensitive data is not exposed while still allowing useful debugging information for developers.
    ///
    /// - Parameters:
    ///   - level: The severity level of the log (info, error, or debug).
    ///   - message: The log message to be recorded.
    func log(_ level: LogLevel, _ message: String) {
        switch level {
        case .info:
            /// Public logs: Visible to SDK users and system logs.
            logger.info("\(message, privacy: .public)")
        case .error:
            /// Private logs: Hidden from SDK users, but accessible to developers via debugging tools.
            logger.error("\(message, privacy: .private)")
        case .debug:
            /// Private logs: Debug information is restricted to prevent exposure in public logs.
            logger.debug("\(message, privacy: .private)")
        }
    }
}

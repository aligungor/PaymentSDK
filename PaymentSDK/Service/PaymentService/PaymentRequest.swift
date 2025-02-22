// MARK: -  Struct
struct PaymentRequest {
    let amount: Decimal
    let currency: String
    let recipient: String
    
    init(config: PaymentConfig) {
        self.amount = config.amount
        self.currency = config.currency
        self.recipient = config.recipient
    }
}

// MARK: - Request
extension PaymentRequest: Request {
    var host: Host {
        .mock
    }
    
    var method: HTTPMethod {
        .POST
    }
    
    var endpoint: Endpoint {
        .payment
    }
}

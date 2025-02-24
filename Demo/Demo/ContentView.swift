import PaymentSDK
import SwiftUI

struct ContentView: View {
    @State private var amount: String = ""
    @State private var currency: String = ""
    @State private var recipientID: String = ""

    @State private var paymentStatus: String = "No payment made yet"
    
    private let payment = Payment(
        apiKey: "16aa63086ce05729095c574fd14cfb58"
    )

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Amount", text: $amount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)

                TextField("Currency (e.g., USD, EUR)", text: $currency)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.allCharacters)

                TextField("Recipient ID", text: $recipientID)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    processPayment()
                }) {
                    Text("Pay")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primary)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Text(paymentStatus)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()

                Spacer()
            }
            .padding()
            .navigationTitle("PaymentSDK Demo")
            .background(.mint)
        }
    }

    private func processPayment() {
        updatePaymentStatus("")
        guard let amount = Decimal(string: amount) else {
            return
        }
        
        let paymentConfig = PaymentConfig(
            amount: amount,
            currency: currency,
            recipient: recipientID
        )
        
        Task {
            do {
                let response = try await payment.make(config: paymentConfig)
                updatePaymentStatus("Payment successful: \(response)")
            } catch {
                updatePaymentStatus("Error: \(error.localizedDescription)")
            }
        }
    }
    
    @MainActor
    private func updatePaymentStatus(_ status: String) {
        paymentStatus = status
    }
}

#Preview {
    ContentView()
}

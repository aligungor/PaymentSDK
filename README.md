# PaymentSDK

PaymentSDK is a modular and secure Swift framework designed to facilitate API-based payment transactions. It provides secure API key management, structured logging, and supports multiple asynchronous programming paradigms.

## Features

- **Secure API Key Management**: Stores API keys securely using Keychain.
- **Flexible Asynchronous Payment Processing**: Supports `async/await`, completion handlers, and Combine.
- **Comprehensive Logging System**: Logs payment process details for debugging and monitoring.
- **Configurable Retry Mechanism**: Ensures reliable transaction execution with customizable retry attempts.
- **Unit Test Coverage**: Includes mock services and structured test cases.
- **Best Practices Compliance**: Follows clean architecture, error handling, logging, and SOLID principles.
- **REST API Interaction**: Implements network requests efficiently and securely.
- **Demo App Included**: A sample app is provided to demonstrate SDK usage.

## Requirements

- **iOS**: Version 16.0 or later
- **Xcode**: Version 16.2 or later
- **Swift**: Version 5.9 or later

## Installation

### Swift Package Manager

To integrate PaymentSDK into your project using Swift Package Manager:

1. Open your project in Xcode.
2. Navigate to `File` > `Add Packages`.
3. Enter the repository URL: `https://github.com/aligungor/PaymentSDK`
4. Select the version and add the package to your project.

## Usage

### Initialization

Before processing payments, initialize the SDK with your API credentials:

```swift
import PaymentSDK

let payment = Payment(apiKey: "your_api_key")
```

### Processing a Payment

To process a payment request:

```swift
let config = PaymentConfig(amount: 1000, currency: "USD", retryCount: 2)

do {
    let response = try await payment.make(config: config)
    print("Payment successful: \(response)")
} catch {
    print("Payment failed: \(error.localizedDescription)")
}
```

### Using Completion Handler

```swift
payment.make(config: config) { result in
    switch result {
    case .success(let response):
        print("Payment successful: \(response)")
    case .failure(let error):
        print("Payment failed: \(error.localizedDescription)")
    }
}
```

### Using Combine

```swift
let cancellable = payment.make(config: config)
    .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
            print("Payment completed")
        case .failure(let error):
            print("Payment failed: \(error.localizedDescription)")
        }
    }, receiveValue: { response in
        print("Payment response: \(response)")
    })
```

### Clearing API Key

```swift
payment.clearAPIKey()
```

## Examples

For a complete example, refer to the `Demo` directory in the repository, which includes a sample project demonstrating the integration and usage of PaymentSDK.

## Testing

- Mock services are included in `Tests/Mock` for unit testing.
- Structured unit tests ensure reliable payment processing and API key handling.
- Customizable mock responses simulate different API behaviors.

## Building with GitHub Actions

PaymentSDK is continuously built and tested using GitHub Actions. The provided workflow automates the process of building an `XCFramework`, which can be used in your project.

### **How to Build the XCFramework Using GitHub Actions**
1. Go to the **"Actions"** tab in your GitHub repository.
2. Select the **"Build and Release PaymentSDK XCFramework"** workflow.
3. Click **"Run workflow"** to start the build process.
4. Once the build completes, download the generated `PaymentSDK.xcframework.zip` from the workflow artifacts.
5. Extract the zip file and add `PaymentSDK.xcframework` to your Xcode project.

### **Using the XCFramework**
After downloading and extracting `PaymentSDK.xcframework`, follow these steps to integrate it into your Xcode project:
1. Drag and drop the extracted `PaymentSDK.xcframework` into your Xcode project's **Frameworks, Libraries, and Embedded Content** section.
2. In the **General** tab of your project settings, ensure that `PaymentSDK.xcframework` is set to **"Embed & Sign"**.
3. Import the SDK into your Swift files:

```swift
import PaymentSDK

let payment = Payment(apiKey: "your_api_key")
```

Your project is now ready to use PaymentSDK! 🚀

## Deliverables

- **Source Code**: Available in a GitHub repository.
- **README Documentation**: Comprehensive setup instructions and usage examples.
- **Demo App**: A sample application demonstrating SDK integration.

## Support

For issues and feature requests, please use the [GitHub Issues](https://github.com/aligungor/PaymentSDK/issues) page.

---

*Note: Ensure you replace placeholder values like `"your_api_key"` with your actual credentials and configure your project settings as needed.*


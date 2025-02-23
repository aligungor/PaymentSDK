import Foundation

// MARK: - Enum
enum Host: String {
    case mock = "https://mock.api.payment"
    
    var url: URL? {
        URL(string: rawValue)
    }
}

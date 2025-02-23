import Foundation
import os

// MARK: - Enum
enum LogLevel {
    case info, error, debug

    var osLogType: OSLogType {
        switch self {
        case .info: return .info
        case .error: return .error
        case .debug: return .debug
        }
    }
}

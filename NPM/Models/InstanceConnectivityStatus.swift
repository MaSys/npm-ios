import Foundation

enum InstanceConnectivityStatus: Equatable {
    case connected
    case authenticationFailed
    case serverUnavailable

    var isRetryable: Bool {
        switch self {
        case .connected:
            return false
        case .authenticationFailed, .serverUnavailable:
            return true
        }
    }
}

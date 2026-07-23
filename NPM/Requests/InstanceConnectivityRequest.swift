import Foundation

class InstanceConnectivityRequest {
    static func status(
        statusCode: Int?,
        hasTransportError: Bool
    ) -> InstanceConnectivityStatus {
        if hasTransportError {
            return .serverUnavailable
        }

        guard let statusCode else {
            return .serverUnavailable
        }

        switch statusCode {
        case 200..<300:
            return .connected
        case 401, 403:
            return .authenticationFailed
        default:
            return .serverUnavailable
        }
    }
}

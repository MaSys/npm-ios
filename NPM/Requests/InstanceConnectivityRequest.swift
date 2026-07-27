import Alamofire
import Foundation

class InstanceConnectivityRequest {
    static func request(baseURL: String, token: String) -> URLRequest? {
        guard let baseURL = URL(string: baseURL) else {
            return nil
        }

        let url = baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("users")
            .appendingPathComponent("me")
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }

    static func check(
        userDefaults: UserDefaults = .standard,
        session: Session = AF,
        completionHandler: @escaping (InstanceConnectivityStatus) -> Void
    ) {
        guard let baseURL = userDefaults.string(forKey: "npm_server_url"),
              let authData = userDefaults.data(forKey: "npm_auth"),
              let auth = try? JSONDecoder().decode(Auth.self, from: authData),
              let request = request(baseURL: baseURL, token: auth.token) else {
            DispatchQueue.main.async {
                completionHandler(.authenticationFailed)
            }
            return
        }

        session.request(request)
            .validate(statusCode: 200..<600)
            .response { response in
                let result = status(
                    statusCode: response.response?.statusCode,
                    hasTransportError: response.error != nil
                )
                DispatchQueue.main.async {
                    completionHandler(result)
                }
            }
    }

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

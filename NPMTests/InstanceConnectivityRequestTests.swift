import XCTest
@testable import NPM

final class InstanceConnectivityRequestTests: XCTestCase {
    func testSuccessfulResponseIsConnected() {
        XCTAssertEqual(
            InstanceConnectivityRequest.status(statusCode: 200, hasTransportError: false),
            .connected
        )
    }

    func testUnauthorizedResponseIsAuthenticationFailure() {
        XCTAssertEqual(
            InstanceConnectivityRequest.status(statusCode: 401, hasTransportError: false),
            .authenticationFailed
        )
    }

    func testForbiddenResponseIsAuthenticationFailure() {
        XCTAssertEqual(
            InstanceConnectivityRequest.status(statusCode: 403, hasTransportError: false),
            .authenticationFailed
        )
    }

    func testServerErrorIsUnavailable() {
        XCTAssertEqual(
            InstanceConnectivityRequest.status(statusCode: 500, hasTransportError: false),
            .serverUnavailable
        )
    }

    func testTransportErrorIsUnavailable() {
        XCTAssertEqual(
            InstanceConnectivityRequest.status(statusCode: nil, hasTransportError: true),
            .serverUnavailable
        )
    }

    func testMissingStoredAuthenticationReturnsAuthenticationFailure() {
        let defaults = UserDefaults(suiteName: #function)!
        defaults.set("https://npm.example.com", forKey: "npm_server_url")

        let expectation = expectation(description: "completion")
        InstanceConnectivityRequest.check(userDefaults: defaults) { status in
            XCTAssertEqual(status, .authenticationFailed)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testRequestUsesAuthenticatedCurrentUserEndpoint() throws {
        let request = try XCTUnwrap(
            InstanceConnectivityRequest.request(
                baseURL: "https://npm.example.com",
                token: "test-token"
            )
        )

        XCTAssertEqual(request.url?.path, "/api/users/me")
        XCTAssertEqual(
            request.value(forHTTPHeaderField: "Authorization"),
            "Bearer test-token"
        )
    }
}

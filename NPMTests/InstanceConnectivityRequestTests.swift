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
}

//
//  RequestTests.swift
//  LXSummaryTests
//
//  Created by LingXiao Dai on 2023/7/21.
//

import XCTest
import Alamofire

final class RequestTests: BaseTestCase {

    func testRequestResponse() {
        let url = Endpoint.get.url
        let expectation = expectation(description: "GET request should succeed: \(url)")
        var response: DataResponse<Data?, AFError>?

        AF.request(url, parameters: ["foo": "bar"])
            .response { resp in
                response = resp
                expectation.fulfill()
            }

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNotNil(response?.response)
        XCTAssertNotNil(response?.data)
        XCTAssertNil(response?.error)
    }

    func testRequestResponseWithProgress() {
        let byteCount = 50 * 1024
        let url = Endpoint.bytes(byteCount).url

        let expectation = expectation(description: "Bytes download progress should be reported: \(url)")

        var progressValues: [Double] = []
        var response: DataResponse<Data?, AFError>?

        // When
        AF.request(url)
            .downloadProgress { progress in
                print("progress == ", progress.fractionCompleted)
                progressValues.append(progress.fractionCompleted)
            }
            .response { resp in
                response = resp
                expectation.fulfill()
            }

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNotNil(response?.response)
        XCTAssertNotNil(response?.data)
        XCTAssertNil(response?.error)

        var previousProgress: Double = progressValues.first ?? 0.0

        for progress in progressValues {
            XCTAssertGreaterThanOrEqual(progress, previousProgress)
            previousProgress = progress
        }

        if let lastProgressValue = progressValues.last {
            XCTAssertEqual(lastProgressValue, 1.0)
        } else {
            XCTFail("last item in progressValues should not be nil")
        }
    }

    func testPOSTRequestWithUnicodeParameters() {
        // Given
        let parameters = ["french": "français",
                          "japanese": "日本語",
                          "arabic": "العربية",
                          "emoji": "😃"]

        let expectation = expectation(description: "request should succeed")

        var response: DataResponse<TestResponse, AFError>?

        // When
        AF.request(.method(.post), parameters: parameters)
            .responseDecodable(of: TestResponse.self) { closureResponse in
                response = closureResponse
                expectation.fulfill()
            }

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNotNil(response?.response)
        XCTAssertNotNil(response?.data)

        if let form = response?.result.success?.form {
            XCTAssertEqual(form["french"], parameters["french"])
            XCTAssertEqual(form["japanese"], parameters["japanese"])
            XCTAssertEqual(form["arabic"], parameters["arabic"])
            XCTAssertEqual(form["emoji"], parameters["emoji"])
        } else {
            XCTFail("form parameter in JSON should not be nil")
        }
    }

    func testHTTPBasicAuthenticationFailsWithInvalidCredentials() {
        // Given
        let session = Session()
        let endpoint = Endpoint.basicAuth()
        let expectation = expectation(description: "\(endpoint.url) 401")

        var response: DataResponse<Data?, AFError>?

        // When
        session.request(endpoint)
            .authenticate(username: "invalid", password: "credentials")
            .response { resp in
                response = resp
                expectation.fulfill()
            }

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNotNil(response?.response)
        XCTAssertEqual(response?.response?.statusCode, 401)
        XCTAssertNil(response?.data)
        XCTAssertNil(response?.error)
    }

    func testHTTPBasicAuthenticationWithValidCredentials() {
        // Given
        let session = Session()
        let user = "user1", password = "password"
        let endpoint = Endpoint.basicAuth(forUser: user, password: password)
        let expectation = expectation(description: "\(endpoint.url) 200")

        var response: DataResponse<Data?, AFError>?

        // When
        session.request(endpoint)
            .authenticate(username: user, password: password)
            .response { resp in
                response = resp
                expectation.fulfill()
            }

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNotNil(response?.response)
        XCTAssertEqual(response?.response?.statusCode, 200)
        XCTAssertNotNil(response?.data)
        XCTAssertNil(response?.error)
    }
}

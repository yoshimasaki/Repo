//
//  GitHubApiClientTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by Yoshihisa Masaki on 2021/03/31.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import XCTest
@testable import iOSEngineerCodeCheck

class GitHubApiClientTests: XCTestCase {

    var client: GitHubApiClient!
    var fetcher: MockURLFetcher!

    override func setUpWithError() throws {
        self.fetcher = MockURLFetcher()
        self.client = GitHubApiClient(fetcher: self.fetcher)
    }

    override func tearDownWithError() throws {
        self.client = nil
        self.fetcher = nil
    }

    func testSearchUrl() throws {
        var url = try XCTUnwrap(try? client.searchUrl(with: "swift"))
        XCTAssertEqual(url.absoluteString, "https://api.github.com/search/repositories?q=swift")

        url = try XCTUnwrap(try? client.searchUrl(with: "swift linked list"))
        XCTAssertEqual(url.absoluteString, "https://api.github.com/search/repositories?q=swift%20linked%20list")
    }

    func testSearchRepository_success() throws {
        let data = try XCTUnwrap(SearchResponseStub.searchResponseJsonString.data(using: .utf8))
        let url = try XCTUnwrap(try? client.searchUrl(with: "swift"))
        let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)

        fetcher.response = httpResponse
        fetcher.data = data

        let expectation = XCTestExpectation(description: "Search repository")

        client.searchRepository(by: "swift") { (result) in
            defer {
                expectation.fulfill()
            }

            switch result {
            case .failure(let error):
                XCTFail(error.errorDescription ?? "")

            case .success(let repository):
                XCTAssertEqual(repository.count, 1)
            }
        }

        wait(for: [expectation], timeout: 1)
    }

    func testSearchRepository_invalid_status_code() throws {
        let data = try XCTUnwrap(SearchResponseStub.searchResponseJsonString.data(using: .utf8))
        let url = try XCTUnwrap(try? client.searchUrl(with: "swift"))
        let httpResponse = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)

        fetcher.response = httpResponse
        fetcher.data = data

        let expectation = XCTestExpectation(description: "Search repository")

        client.searchRepository(by: "swift") { (result) in
            defer {
                expectation.fulfill()
            }

            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .invalidHttpStatus(statusCode: 404))

            case .success:
                XCTFail("Never reach")
            }
        }

        wait(for: [expectation], timeout: 1)
    }

    func testSearchRepository_fetch_error() throws {

        fetcher.error = GitHubApiClientError.faildFetch(error: GitHubApiClientError.cannotMakeSearchUrl(searchTerm: "swift"))

        let expectation = XCTestExpectation(description: "Search repository")

        client.searchRepository(by: "swift") { (result) in
            defer {
                expectation.fulfill()
            }

            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .faildFetch(error: GitHubApiClientError.cannotMakeSearchUrl(searchTerm: "swift")))

            case .success:
                XCTFail("Never reach")
            }
        }

        wait(for: [expectation], timeout: 1)
    }

    func testSearchRepository_json_decode_error() throws {
        let data = try XCTUnwrap("".data(using: .utf8))
        let url = try XCTUnwrap(try? client.searchUrl(with: "swift"))
        let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)

        fetcher.response = httpResponse
        fetcher.data = data

        let expectation = XCTestExpectation(description: "Search repository")

        client.searchRepository(by: "swift") { (result) in
            defer {
                expectation.fulfill()
            }

            switch result {
            case .failure(let error):
                XCTAssertEqual(error, .jsonDecodeError(error: GitHubApiClientError.cannotMakeSearchUrl(searchTerm: "swift")))

            case .success:
                XCTFail("Never reach")
            }
        }

        wait(for: [expectation], timeout: 1)
    }
}

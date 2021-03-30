//
//  URLFetcherTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by Yoshihisa Masaki on 2021/03/31.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import XCTest
@testable import iOSEngineerCodeCheck

class URLFetcherTests: XCTestCase {

    var fetcher: URLFetcher!

    override func setUpWithError() throws {
        fetcher = URLFetcher()
    }

    override func tearDownWithError() throws {
        fetcher = nil
    }

    func testFetch() {
        let expectation = XCTestExpectation(description: "Fetching URL")
        let url = URL(string: "https:www.example.com/")!

        fetcher.fetch(url: url) { (data, response, error) in
            defer {
                expectation.fulfill()
            }

            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertNotNil(data)

            do {
                let httpResponse = try XCTUnwrap(response as? HTTPURLResponse)
                XCTAssertEqual(httpResponse.statusCode, 200)
            } catch {
                XCTFail("Response is not HTTP response")
            }
        }

        wait(for: [expectation], timeout: 3)
    }
}

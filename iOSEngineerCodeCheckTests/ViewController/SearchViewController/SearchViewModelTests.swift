//
//  SearchViewModelTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by Yoshihisa Masaki on 2021/03/31.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import XCTest
@testable import iOSEngineerCodeCheck

class SearchViewModelTests: XCTestCase {

    var viewModel: SearchViewModel!
    var client: GitHubApiClient!
    var fetcher: MockURLFetcher!

    override func setUpWithError() throws {
        self.fetcher = MockURLFetcher()
        self.client = GitHubApiClient(fetcher: self.fetcher)
        self.viewModel = SearchViewModel(apiClient: self.client)
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
        self.client = nil
        self.fetcher = nil
    }

    func testSearchRepository_success() throws {
        let data = try XCTUnwrap(SearchResponseStub.searchResponseJsonString.data(using: .utf8))
        let url = try XCTUnwrap(try? client.searchUrl(with: "swift"))
        let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)

        fetcher.response = httpResponse
        fetcher.data = data

        XCTAssertEqual(viewModel.state, .none)
        viewModel.searchRepository(by: "swift")
        XCTAssertEqual(viewModel.state, .repositoriesUpdated)
    }

    func testSearchRepository_invalid_status_code() throws {
        let data = try XCTUnwrap(SearchResponseStub.searchResponseJsonString.data(using: .utf8))
        let url = try XCTUnwrap(try? client.searchUrl(with: "swift"))
        let httpResponse = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)

        fetcher.response = httpResponse
        fetcher.data = data

        XCTAssertEqual(viewModel.state, .none)
        XCTAssertNil(viewModel.error)
        viewModel.searchRepository(by: "swift")
        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.error, .invalidHttpStatus(statusCode: 404))
    }

    func testSearchRepository_fetch_error() throws {
        fetcher.error = GitHubApiClientError.faildFetch(error: GitHubApiClientError.cannotMakeSearchUrl(searchTerm: "swift"))

        XCTAssertEqual(viewModel.state, .none)
        XCTAssertNil(viewModel.error)
        viewModel.searchRepository(by: "swift")
        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.error, .faildFetch(error: GitHubApiClientError.cannotMakeSearchUrl(searchTerm: "swift")))
    }

    func testSearchRepository_json_decode_error() throws {
        let data = try XCTUnwrap("".data(using: .utf8))
        let url = try XCTUnwrap(try? client.searchUrl(with: "swift"))
        let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)

        fetcher.response = httpResponse
        fetcher.data = data

        XCTAssertEqual(viewModel.state, .none)
        XCTAssertNil(viewModel.error)
        viewModel.searchRepository(by: "swift")
        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.error, .jsonDecodeError(error: GitHubApiClientError.cannotMakeSearchUrl(searchTerm: "swift")))
    }

    func testLastSelectedRepository() throws {
        let data = try XCTUnwrap(SearchResponseStub.searchResponseJsonString.data(using: .utf8))
        let url = try XCTUnwrap(try? client.searchUrl(with: "swift"))
        let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)

        fetcher.response = httpResponse
        fetcher.data = data

        viewModel.searchRepository(by: "swift")

        let repository = viewModel.lastSelectedRepository
        XCTAssertEqual(repository.fullName, "dtrupenn/Tetris")
    }

    func testIndexPathForRepository() throws {
        let data = try XCTUnwrap(SearchResponseStub.searchResponseJsonString.data(using: .utf8))
        let url = try XCTUnwrap(try? client.searchUrl(with: "swift"))
        let httpResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)

        fetcher.response = httpResponse
        fetcher.data = data

        viewModel.searchRepository(by: "swift")

        let indexPath = viewModel.indexPath(for: viewModel.repositories[0])
        XCTAssertEqual(indexPath, IndexPath(item: 0, section: 0))
    }
}

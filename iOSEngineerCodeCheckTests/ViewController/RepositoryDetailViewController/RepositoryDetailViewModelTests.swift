//
//  RepositoryDetailViewModelTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by Yoshihisa Masaki on 2021/03/31.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import XCTest
@testable import iOSEngineerCodeCheck

class RepositoryDetailViewModelTests: XCTestCase {

    var viewModel: RepositoryDetailViewModel!
    var fetcher: MockURLFetcher!

    override func setUpWithError() throws {
        self.fetcher = MockURLFetcher()
        self.viewModel = RepositoryDetailViewModel(fetcher: self.fetcher)
        self.viewModel.repository = makeRepository()
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
        self.fetcher = nil
    }

    func testRepositoryName() {
        XCTAssertEqual(viewModel.repositoryName, "dtrupenn/Tetris")
    }

    func testLanguageText() {
        XCTAssertEqual(viewModel.languageText, "Written in Assembly")
    }

    func testStarCountText() {
        XCTAssertEqual(viewModel.starCountText, "1 stars")
    }

    func testWatchCountText() {
        XCTAssertEqual(viewModel.watchCountText, "1 watchers")
    }

    func testForkCountText() {
        XCTAssertEqual(viewModel.forkCountText, "0 forks")
    }

    func testOpenIssueCountText() {
        XCTAssertEqual(viewModel.openIssueCountText, "0 open issues")
    }

    func testFetchAvatarImage_success() {
        let image = UIImage(systemName: "star")!
        let imageData = image.jpegData(compressionQuality: 1)
        let httpResponse = HTTPURLResponse(url: URL(string: "https://www.example.com/")!, statusCode: 200, httpVersion: nil, headerFields: nil)

        fetcher.data = imageData
        fetcher.response = httpResponse

        let expectation = XCTestExpectation(description: "Fetch avatar image")

        viewModel.fetchAvatarImage { (result) in
            switch result {
            case .failure:
                XCTFail("Never reach")

            case .success(let image):
                XCTAssertNotNil(image)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func makeRepository() -> RepositoryEntity {
        let data = SearchResponseStub.searchResponseJsonString.data(using: .utf8)!
        let result = try? JSONDecoder.decoder.decode(SearchResultEntity.self, from: data)

        return result!.items.first!
    }
}

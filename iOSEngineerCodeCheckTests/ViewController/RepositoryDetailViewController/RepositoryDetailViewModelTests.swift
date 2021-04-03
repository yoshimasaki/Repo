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

    override func setUpWithError() throws {
        self.viewModel = RepositoryDetailViewModel()
        self.viewModel.repositories = makeRepositories()
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
    }

    func makeRepositories() -> [RepositoryEntity] {
        let data = SearchResponseStub.searchResponseJsonString.data(using: .utf8)!
        let result = try? JSONDecoder.decoder.decode(SearchResultEntity.self, from: data)

        return result!.items
    }
}

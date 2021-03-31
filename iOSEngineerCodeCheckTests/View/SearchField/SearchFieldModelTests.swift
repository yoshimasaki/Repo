//
//  SearchFieldModelTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by Yoshihisa Masaki on 2021/03/31.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import XCTest
@testable import iOSEngineerCodeCheck

class SearchFieldModelTests: XCTestCase {

    var viewModel: SearchFieldModel!

    override func setUpWithError() throws {
        self.viewModel = SearchFieldModel()
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
    }

    func testState_updatePlaceholderHidden() {
        XCTAssertEqual(viewModel.state, .none)

        viewModel.text = "swift"
        XCTAssertEqual(viewModel.state, .updatePlaceholderHidden(true))

        viewModel.text = ""
        XCTAssertEqual(viewModel.state, .updatePlaceholderHidden(false))
    }
}

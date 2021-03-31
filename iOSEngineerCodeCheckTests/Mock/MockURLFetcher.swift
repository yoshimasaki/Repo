//
//  MockURLFetcher.swift
//  iOSEngineerCodeCheckTests
//
//  Created by Yoshihisa Masaki on 2021/03/31.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation
@testable import iOSEngineerCodeCheck

final class MockURLFetcher: URLFetchable {

    var data: Data?
    var response: HTTPURLResponse?
    var error: Error?

    func fetch(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        completion(data, response, error)
    }

    func cancelFetch() {}
}

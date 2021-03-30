//
//  URLFetcher.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/03/31.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

final class URLFetcher: URLFetchable {

    private let session: URLSession
    private var dataTask: URLSessionDataTask?

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func fetch(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        dataTask = session.dataTask(with: url) { (data, response, error) in
            completion(data, response, error)
        }

        dataTask!.resume()
    }

    func cancelFetch() {
        dataTask?.cancel()
    }
}

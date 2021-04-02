//
//  URLRequest+UserAgent.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/02.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

extension URLRequest {

    static func urlRequest(with url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue(UserAgent.userAgent, forHTTPHeaderField: "User-Agent")

        return request
    }
}

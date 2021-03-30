//
//  URLFetchable.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/03/31.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

protocol URLFetchable {
    func fetch(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
    func cancelFetch()
}

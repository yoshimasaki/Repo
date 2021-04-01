//
//  RepositoryDetailViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/03/30.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

final class RepositoryDetailViewModel {

    var repositories: [RepositoryEntity] = []
    var lastSelectedItemIndex = 0

    var lastSelectedItemIndexPath: IndexPath {
        IndexPath(item: lastSelectedItemIndex, section: 0)
    }

    private let fetcher: URLFetchable

    init(fetcher: URLFetchable = URLFetcher()) {
        self.fetcher = fetcher
    }
}

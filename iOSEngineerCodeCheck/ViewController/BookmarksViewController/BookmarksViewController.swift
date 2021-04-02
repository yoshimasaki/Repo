//
//  BookmarksViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/02.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

final class BookmarksViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
    }

    private func configureViews() {
        view.backgroundColor = .systemBackground
    }
}

extension BookmarksViewController: TabBarItemProvidable {

    var aTabBarItem: TabBarItem? {
        let bookmarkIcon = UIImage(systemName: "bookmark")
        assert(bookmarkIcon != nil, "bookmark is not exist in SF Symbols")

        return TabBarItem(icon: bookmarkIcon!, title: "Bookmark")
    }
}

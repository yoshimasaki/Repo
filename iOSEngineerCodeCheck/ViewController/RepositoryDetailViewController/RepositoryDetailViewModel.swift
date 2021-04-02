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
    var lastSelectedItemIndexPath: IndexPath = IndexPath(item: 0, section: 0)

    private let persistent: Persistent

    init(persistent: Persistent = Persistent.shared) {
        self.persistent = persistent
    }

    func bookmarkRepository(_ repository: RepositoryEntity) {
        let context = persistent.viewContext

        context.perform {
            _ = RepositoryBookmark.repositoryBookmark(with: repository, context: context)

            self.persistent.saveContext()
        }
    }
}

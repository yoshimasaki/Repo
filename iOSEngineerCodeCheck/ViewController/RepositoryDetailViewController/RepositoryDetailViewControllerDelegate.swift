//
//  RepositoryDetailViewControllerDelegate.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/02.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

protocol RepositoryDetailViewControllerDelegate: class {
    func repositoryDetailViewController(_ detailViewController: RepositoryDetailViewController, willCloseWithVisible repository: RepositoryEntity)
}

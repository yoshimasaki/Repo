//
//  SearchResultEntity.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/03/31.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

struct SearchResultEntity: Decodable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [RepositoryEntity]
}

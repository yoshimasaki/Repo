//
//  RepositoryOwnerEntity.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/03/31.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

struct RepositoryOwnerEntity: Decodable {
    let login: String?
    let avatarUrl: String?
    let reposUrl: String?
    let url: String?
}

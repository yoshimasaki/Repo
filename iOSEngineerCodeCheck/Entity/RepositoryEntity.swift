//
//  RepositoryEntity.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/03/31.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

struct RepositoryEntity: Decodable {
    let createdAt: Date
    let pushedAt: Date
    let updatedAt: Date
    let description: String?
    let forksCount: Int
    let fullName: String?
    let htmlUrl: String?
    let language: String?
    let languagesUrl: String?
    let license: RepositoryLicenseEntity?
    let name: String?
    let openIssuesCount: Int
    let avatarUrl: String?
    let reposUrl: String?
    let url: String?
    let stargazersCount: Int
    let watchersCount: Int
    let owner: RepositoryOwnerEntity
}

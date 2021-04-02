//
//  RepositoryBookmark+CoreDataClass.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/02.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//
//

import Foundation
import CoreData

@objc(RepositoryBookmark)
public final class RepositoryBookmark: NSManagedObject {

    static func repositoryBookmark(with entity: RepositoryEntity, context: NSManagedObjectContext) -> RepositoryBookmark {
        let bookmark = RepositoryBookmark(context: context)

        bookmark.createdAt = entity.createdAt
        bookmark.pushedAt = entity.pushedAt
        bookmark.updatedAt = entity.updatedAt
        bookmark.descriptionText = entity.description
        bookmark.forksCount = Int64(entity.forksCount)
        bookmark.fullName = entity.fullName
        bookmark.htmlUrl = entity.htmlUrl
        bookmark.language = entity.language
        bookmark.languagesUrl = entity.languagesUrl
        bookmark.name = entity.name
        bookmark.openIssuesCount = Int64(entity.openIssuesCount)
        bookmark.avatarUrl = entity.avatarUrl
        bookmark.reposUrl = entity.reposUrl
        bookmark.url = entity.url
        bookmark.stargazersCount = Int64(entity.stargazersCount)
        bookmark.watchersCount = Int64(entity.watchersCount)
        bookmark.repositoryOwner = RepositoryOwner.repositoryOwner(with: entity.owner, contenxt: context)

        return bookmark
    }

    public override func awakeFromInsert() {
        super.awakeFromInsert()

        setPrimitiveValue(UUID(), forKey: "repositoryBookmarkID")
        setPrimitiveValue(Date(), forKey: "bookmarkCreationDate")
    }

    var repositoryEntity: RepositoryEntity? {
        guard let ownerEntity = repositoryOwner?.repositoryOwnerEntity else {
            return nil
        }

        let createdAt = self.createdAt ?? .distantPast
        let pushedAt = self.pushedAt ?? .distantPast
        let updatedAt = self.updatedAt ?? .distantPast

        let entity = RepositoryEntity(createdAt: createdAt,
                 pushedAt: pushedAt,
                 updatedAt: updatedAt,
                 description: descriptionText,
                 forksCount: Int(forksCount),
                 fullName: fullName,
                 htmlUrl: htmlUrl,
                 language: language,
                 languagesUrl: languagesUrl,
                 license: nil,
                 name: name,
                 openIssuesCount: Int(openIssuesCount),
                 avatarUrl: avatarUrl,
                 reposUrl: reposUrl,
                 url: url,
                 stargazersCount: Int(stargazersCount),
                 watchersCount: Int(watchersCount),
                 owner: ownerEntity)

        return entity
    }
}

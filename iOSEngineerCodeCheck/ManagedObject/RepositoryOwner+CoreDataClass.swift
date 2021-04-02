//
//  RepositoryOwner+CoreDataClass.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/02.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//
//

import Foundation
import CoreData

@objc(RepositoryOwner)
public final class RepositoryOwner: NSManagedObject {

    static func repositoryOwner(with entity: RepositoryOwnerEntity, contenxt: NSManagedObjectContext) -> RepositoryOwner {
        let owner = RepositoryOwner(context: contenxt)

        owner.login = entity.login
        owner.avatarUrl = entity.avatarUrl
        owner.reposUrl = entity.reposUrl
        owner.url = entity.url

        return owner
    }

    public override func awakeFromInsert() {
        super.awakeFromInsert()

        setPrimitiveValue(UUID(), forKey: "repositoryOwnerID")
    }

    var repositoryOwnerEntity: RepositoryOwnerEntity {
        RepositoryOwnerEntity(login: login,
                              avatarUrl: avatarUrl,
                              reposUrl: reposUrl,
                              url: url)
    }
}

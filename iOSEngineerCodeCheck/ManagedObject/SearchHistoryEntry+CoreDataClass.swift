//
//  SearchHistoryEntry+CoreDataClass.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/03.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//
//

import Foundation
import CoreData

@objc(SearchHistoryEntry)
public final class SearchHistoryEntry: NSManagedObject {

    static func searchHistoryEntry(searchTerm: String, context: NSManagedObjectContext) -> SearchHistoryEntry {
        let entry = SearchHistoryEntry(context: context)

        entry.searchedDate = Date()
        entry.searchTerm = searchTerm

        return entry
    }
}

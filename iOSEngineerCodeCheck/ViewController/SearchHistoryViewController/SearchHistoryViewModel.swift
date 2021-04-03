//
//  SearchHistoryViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/03.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation
import CoreData

final class SearchHistoryViewModel {

    weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate? {
        didSet {
            fetchedResultsController.delegate = fetchedResultsControllerDelegate
        }
    }

    private let persistent: Persistent

    private lazy var fetchedResultsController: NSFetchedResultsController<SearchHistoryEntry> = {
        let request: NSFetchRequest<SearchHistoryEntry> = SearchHistoryEntry.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "searchedDate", ascending: false)]
        request.fetchBatchSize = 50
        request.fetchLimit = 50

        let context = persistent.viewContext

        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = fetchedResultsControllerDelegate

        return controller
    }()

    init(persistent: Persistent = Persistent.shared) {
        self.persistent = persistent
    }

    func populateData() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to fetch \(fetchedResultsController.fetchRequest)")
        }
    }

    var hasHistoryEntry: Bool {
        searchHistoryCount > 0
    }

    var searchHistoryCount: Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }

    func searchHistoryEntry(for indexPath: IndexPath) -> SearchHistoryEntry {
        fetchedResultsController.object(at: indexPath)
    }

    func insertSearchHistoryEntry(searchTerm: String) {
        let context = persistent.viewContext

        _ = SearchHistoryEntry.searchHistoryEntry(searchTerm: searchTerm, context: context)

        persistent.saveContext()
    }
}

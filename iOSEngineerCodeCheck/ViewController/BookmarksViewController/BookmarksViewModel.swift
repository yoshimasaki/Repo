//
//  BookmarksViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/02.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation
import CoreData
import Combine

// Core Data の NSManagedObject の遅延でデータをロードする fault を有効に使うために plain data object とか使わずにそのまま NSManagedObject を使う方がメモリ効率がいいのでリポジトリパターンとか使っていない。
// Core Data への強い依存があるからテストがしづらいのが課題。
final class BookmarksViewModel {

    weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate? {
        didSet {
            fetchedResultsController.delegate = fetchedResultsControllerDelegate
        }
    }

    @Published var state: BookmarksViewModelState = .none

    private let persistent: Persistent

    private lazy var fetchedResultsController: NSFetchedResultsController<RepositoryBookmark> = {
        let request: NSFetchRequest<RepositoryBookmark> = RepositoryBookmark.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "bookmarkCreationDate", ascending: false)]
        request.fetchBatchSize = 50

        let context = persistent.viewContext

        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = fetchedResultsControllerDelegate

        return controller
    }()

    var repositories: [RepositoryEntity] {
        fetchedResultsController.fetchedObjects?.compactMap { $0.repositoryEntity } ?? []
    }

    var lastSelectedItemIndexPath: IndexPath = IndexPath(item: 0, section: 0)

    var lastSelectedRepository: RepositoryEntity? {
        fetchedResultsController.object(at: lastSelectedItemIndexPath).repositoryEntity
    }

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

    func numberOfItems(in seciton: Int) -> Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }

    func repositoryEntity(for indexPath: IndexPath) -> RepositoryEntity? {
        fetchedResultsController.object(at: indexPath).repositoryEntity
    }

    // MARK: - Search Repository Bookmark
    func searchRepository(by searchTerm: String) {
        if searchTerm.isEmpty {
            fetchedResultsController.fetchRequest.predicate = nil
        } else {
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "fullName CONTAINS[cd] %@", searchTerm)
        }

        populateData()
        state = .repositoriesUpdated
    }

    func cancelSearch() {}

    func indexPath(for repository: RepositoryEntity) -> IndexPath? {
        guard let index = repositories.firstIndex(where: { $0.fullName == repository.fullName }) else {
            return nil
        }

        return IndexPath(item: index, section: 0)
    }

    func deleteBookmark(at indexPath: IndexPath) {
        let context = persistent.viewContext
        let bookmark = fetchedResultsController.object(at: indexPath)

        context.delete(bookmark)

        persistent.saveContext()
    }
}

//
//  Persistent.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/02.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation
import CoreData
import Combine

final class Persistent {

    static let shared = Persistent()

    private var saveSubscription: AnyCancellable?

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Repo")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let nsError = error as NSError? {
                print("Failed to load persistent container - error: \(nsError)")
            }
        })

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)

        return container
    }()

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    init() {
        subscribeViewContextChangeDelaySave()
    }

    private func subscribeViewContextChangeDelaySave() {
       saveSubscription = NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange, object: viewContext)
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (_) in
                self?.saveContext()
            }
    }

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Database save failed - error: \(nserror)")
            }
        }
    }
}

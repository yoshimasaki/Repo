//
//  RepositoryCollectionViewDataSource.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/03/31.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

final class RepositoryCollectionViewDataSource {

    enum Section {
        case main
    }

    struct Item: Hashable {
        let id = UUID()
        let repository: RepositoryEntity

        static func == (lhs: RepositoryCollectionViewDataSource.Item, rhs: RepositoryCollectionViewDataSource.Item) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    typealias DataSouce = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    var dataSource: DataSouce?

    func configreCollectionViewDataSource(collectionView: UICollectionView) {
        dataSource = DataSouce(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RepositoryCell.reuseIdentifier, for: indexPath) as? RepositoryCell else {
                return nil
            }

            let repository = item.repository

            // TODO: need provide repository info to cell
            // cell

            return cell
        })
    }

    func updateDataSource(with repositories: [RepositoryEntity]) {
        assert(dataSource != nil, "Need to configure data source")

        let items = makeItems(from: repositories)
        var snapshot = Snapshot()

        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)

        dataSource?.apply(snapshot)
    }

    private func makeItems(from repositories: [RepositoryEntity]) -> [Item] {
        repositories.map { Item(repository: $0) }
    }
}

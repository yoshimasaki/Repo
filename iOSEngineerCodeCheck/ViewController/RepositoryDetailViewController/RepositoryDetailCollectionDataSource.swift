//
//  RepositoryDetailCollectionDataSource.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/01.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

final class RepositoryDetailCollectionDataSource {

    enum Section {
        case main
    }

    struct Item: Hashable {
        let id = UUID()
        let repository: RepositoryEntity

        static func == (lhs: RepositoryDetailCollectionDataSource.Item, rhs: RepositoryDetailCollectionDataSource.Item) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    typealias DataSouce = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    var dataSource: DataSouce?

    weak var repositoryDetailCellDelegate: RepositoryDetailCellDelegate?

    func configreCollectionViewDataSource(collectionView: UICollectionView) {
        dataSource = DataSouce(collectionView: collectionView, cellProvider: { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RepositoryDetailCell.reuseIdentifier, for: indexPath) as? RepositoryDetailCell else {
                return nil
            }

            cell.repositoryInfoView.repository = item.repository
//            cell.readmePublisher = GitHubReadmePublisher.readmePublisher(for: item.repository)
            cell.delegate = self?.repositoryDetailCellDelegate

            return cell
        })
    }

    func updateDataSource(with repositories: [RepositoryEntity], completion: (() -> Void)? = nil) {
        assert(dataSource != nil, "Need to configure data source")

        let items = makeItems(from: repositories)
        var snapshot = Snapshot()

        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)

        dataSource?.apply(snapshot, animatingDifferences: true, completion: completion)
    }

    private func makeItems(from repositories: [RepositoryEntity]) -> [Item] {
        repositories.map { Item(repository: $0) }
    }
}

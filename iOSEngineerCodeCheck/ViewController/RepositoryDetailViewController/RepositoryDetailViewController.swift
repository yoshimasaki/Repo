//
//  RepositoryDetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class RepositoryDetailViewController: UIViewController {

    var repositories: [RepositoryEntity] {
        get {
            viewModel.repositories
        }
        set {
            viewModel.repositories = newValue
        }
    }

    var lastSelectedItemIndex: Int {
        get {
            viewModel.lastSelectedItemIndex
        }
        set {
            viewModel.lastSelectedItemIndex = newValue
        }
    }

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)

    private let viewModel = RepositoryDetailViewModel()
    private let collectionViewDataSource = RepositoryDetailCollectionDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        configureConstraints()
        registCollectionViewCell()
        configreCollectionViewDataSource()
        collectionViewDataSource.updateDataSource(with: repositories) { [weak self] in
            self?.scrollToLastSelectedItem()
        }
    }

    private func configureViews() {
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.alwaysBounceVertical = false
    }

    private func configureConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configreCollectionViewDataSource() {
        collectionViewDataSource.repositoryDetailCellDelegate = self
        collectionViewDataSource.configreCollectionViewDataSource(collectionView: collectionView)
    }

    private func registCollectionViewCell() {
        collectionView.register(RepositoryDetailCell.self, forCellWithReuseIdentifier: RepositoryDetailCell.reuseIdentifier)
    }

    private var collectionViewLayout: UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }

    private func scrollToLastSelectedItem() {
        collectionView.scrollToItem(at: viewModel.lastSelectedItemIndexPath, at: .centeredHorizontally, animated: false)
    }
}

extension RepositoryDetailViewController: RepositoryDetailCellDelegate {

    func repositoryDetailCellDidTapCloseButton(_ cell: RepositoryDetailCell) {
        navigationController?.popViewController(animated: true)
    }
}

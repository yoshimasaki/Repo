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

    var lastSelectedItemIndexPath: IndexPath {
        get {
            viewModel.lastSelectedItemIndexPath
        }
        set {
            viewModel.lastSelectedItemIndexPath = newValue
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

    func updateVisibleCellCloseButtonVisibility(_ isVisible: Bool, animating: Bool = true) {
        (collectionView.visibleCells as? [RepositoryDetailCell])?.forEach { $0.updateCloseButtonVisibility(isVisible, animating: animating) }
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

    private var collectionViewLayout: UICollectionViewFlowLayout {
        let layout = CenterPagingFlowLayout()

        layout.itemSize = view.bounds.inset(by: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)).size
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        return layout
    }

    private func scrollToLastSelectedItem() {
        collectionView.scrollToItem(at: viewModel.lastSelectedItemIndexPath, at: .centeredHorizontally, animated: false)
    }

    private func currentVisibleRepositoryInfoView(presenting: Bool) -> RepositoryInfoView? {
        // viewController の遷移時に lastSelectedItemIndexPath の cell にスクロールしてない場合があるのでその場合は0個目の cell の infoView を返す。
        let cell: UICollectionViewCell?
        if presenting {
            cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0))
        } else {
            cell = collectionView.cellForItem(at: viewModel.lastSelectedItemIndexPath)
        }

        guard let detailCell = cell as? RepositoryDetailCell else {
            return nil
        }

        return detailCell.repositoryInfoView
    }
}

extension RepositoryDetailViewController: RepositoryDetailCellDelegate {

    func repositoryDetailCellDidTapCloseButton(_ cell: RepositoryDetailCell) {
        navigationController?.popViewController(animated: true)
    }
}

extension RepositoryDetailViewController: TransitionSourceViewProvidable {

    var sourceViewFrameOffset: CGPoint {
        CGPoint(x: .zero, y: view.safeAreaInsets.top)
    }

    func sourceView(for animator: RepositoryInfoViewAnimator) -> UIView? {
        currentVisibleRepositoryInfoView(presenting: animator.isPresenting)
    }
}

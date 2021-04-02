//
//  RepositoryDetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class RepositoryDetailViewController: UIViewController {

    weak var delegate: RepositoryDetailViewControllerDelegate?

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
            cell = collectionView.cellForItem(at: currentVisibleCellIndexPath ?? IndexPath(item: 0, section: 0))
        }

        guard let detailCell = cell as? RepositoryDetailCell else {
            return nil
        }

        return detailCell.repositoryInfoView
    }

    private var currentVisibleCellIndexPath: IndexPath? {
        let xOffset = collectionView.contentOffset.x
        let cells = collectionView.visibleCells

        let minItem = cells.map({ abs($0.frame.minX.distance(to: xOffset)) }).enumerated().min { (lhs, rhs) -> Bool in
            lhs.element < rhs.element
        }

        guard let visibleCellIndex = minItem?.offset else {
            return nil
        }

        let visibleCell = cells[visibleCellIndex]

        return collectionView.indexPath(for: visibleCell)
    }

    private var currentVisibleRepository: RepositoryEntity {
        let indexPath = currentVisibleCellIndexPath ?? IndexPath(item: 0, section: 0)

        return repositories[indexPath.item]
    }
}

extension RepositoryDetailViewController: RepositoryDetailCellDelegate {

    func repositoryDetailCellDidTapCloseButton(_ cell: RepositoryDetailCell) {
        delegate?.repositoryDetailViewController(self, willCloseWithVisible: currentVisibleRepository)
        navigationController?.popViewController(animated: true)
    }

    func repositoryDetailCellDidTapBookmarkButton(_ cell: RepositoryDetailCell) {
        viewModel.bookmarkRepository(currentVisibleRepository)
        // TODO: present notify bezel ui
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

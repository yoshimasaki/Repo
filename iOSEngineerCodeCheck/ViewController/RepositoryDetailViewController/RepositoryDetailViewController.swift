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
    private let notificationView = NotificationView(frame: .zero)

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

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        invalidateColectionViewFlowLayout()
    }

    func updateVisibleCellCloseButtonVisibility(_ isVisible: Bool, animating: Bool = true) {
        (collectionView.visibleCells as? [RepositoryDetailCell])?.forEach { $0.updateCloseButtonVisibility(isVisible, animating: animating) }
    }

    private func configureViews() {
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.alwaysBounceVertical = false

        notificationView.isHidden = true
    }

    private func configureConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        notificationView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(collectionView)
        view.addSubview(notificationView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            notificationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            notificationView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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

        layout.itemSize = layoutItemSize
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.sectionInset = layoutSectionInset

        return layout
    }

    private var layoutItemSize: CGSize {
        view.bounds.inset(by: UIEdgeInsets(top: 0, left: view.safeAreaInsets.left + 24, bottom: 0, right: view.safeAreaInsets.right + 24)).size
    }

    private var layoutSectionInset: UIEdgeInsets {
        UIEdgeInsets(top: 0, left: view.safeAreaInsets.left + 16, bottom: 0, right: view.safeAreaInsets.right + 16)
    }

    private func invalidateColectionViewFlowLayout() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        layout.itemSize = layoutItemSize
        layout.sectionInset = layoutSectionInset
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

    private func presentActivityViewController() {
        guard
            let urlString = currentVisibleRepository.htmlUrl,
            let url = URL(string: urlString)
        else {
            return
        }

        let shareSheet = UIActivityViewController(activityItems: [url], applicationActivities: nil)

        present(shareSheet, animated: true, completion: nil)
    }
}

extension RepositoryDetailViewController: RepositoryDetailCellDelegate {

    func repositoryDetailCellDidTapCloseButton(_ cell: RepositoryDetailCell) {
        delegate?.repositoryDetailViewController(self, willCloseWithVisible: currentVisibleRepository)
        navigationController?.popViewController(animated: true)
    }

    func repositoryDetailCellDidTapBookmarkButton(_ cell: RepositoryDetailCell) {
        if viewModel.bookmarkRepository(currentVisibleRepository) {
            notificationView.show(messages: R.string.localizable.bookmarkIt())
        } else {
            notificationView.show(messages: R.string.localizable.alreadyBookmark())
        }
    }

    func repositoryDetailCellDidTapShareButton(_ cell: RepositoryDetailCell) {
        presentActivityViewController()
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

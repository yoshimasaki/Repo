//
//  BookmarksViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/02.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit
import Combine
import CoreData

// 現状 SearchViewController と BookmarksViewController は同じ構成のコードだが、将来的な機能拡張がどの方向にいくかはわからないので細かく構成を変えやすいように base view controller を作っていない。
final class BookmarksViewController: UIViewController {

    private let searchField = SearchField(frame: .zero)
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)

    private let viewModel = BookmarksViewModel()
    private var subscriptions = Set<AnyCancellable>()

    private var aTabBarController: TabBarController? {
        tabBarController as? TabBarController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        configureConstraints()
        registCollectionViewCell()
        configureCollectionViewDataSource()
        configureViewModel()
        subscribeState()
        subscribeSearchFieldText()
        subscribeSearchFieldState()

        viewModel.populateData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        updateCollectionViewContentInset()
    }

    // MARK: - Configure Views
    private func configureViews() {
        searchField.placeholder = R.string.localizable.searchBookmarks()

        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        collectionView.delegate = self

        navigationController?.delegate = self
    }

    private func configureConstraints() {
        searchField.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(collectionView)
        view.addSubview(searchField)

        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),

            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureViewModel() {
        viewModel.fetchedResultsControllerDelegate = self
    }

    private func configureCollectionViewDataSource() {
        collectionView.dataSource = self
    }

    private func configureCell(for collecitonView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell? {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RepositoryCell.reuseIdentifier, for: indexPath) as? RepositoryCell,
            let repository = viewModel.repositoryEntity(for: indexPath)
        else {
            return nil
        }

        cell.repositoryInfoView.repository = repository

        return cell
    }

    private func registCollectionViewCell() {
        collectionView.register(RepositoryCell.self, forCellWithReuseIdentifier: RepositoryCell.reuseIdentifier)
    }

    private var collectionViewLayout: UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(180))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 24, bottom: 16, trailing: 24)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(180))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }

    private func updateCollectionViewContentInset() {
        collectionView.contentInset.top = searchField.bounds.height + 32
        collectionView.contentInset.bottom = view.bounds.height - (aTabBarController?.floatingTabBar.frame.minY ?? 0)
    }

    // MARK: - Subscriptions
    private func subscribeState() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (state) in
                self?.handleState(state)
            }
            .store(in: &subscriptions)
    }

    private func subscribeSearchFieldText() {
        searchField.$text
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (searchText) in
                self?.handleSearchFieldTextDidChange(searchText)
            }
            .store(in: &subscriptions)
    }

    private func subscribeSearchFieldState() {
        searchField.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (state) in
                self?.handleSearchFiledSate(state)
            }
            .store(in: &subscriptions)
    }

    private func handleState(_ state: BookmarksViewModelState) {
        switch state {
        case .none:
            break

        case .repositoriesUpdated:
            collectionView.reloadData()
        }
    }

    private func handleSearchFieldTextDidChange(_ searchText: String?) {}

    private func handleSearchFiledSate(_ state: SearchFieldState) {
        switch state {
        case .none:
            break

        case .didBeginEditing:
            break

        case .didEndEditing:
            break

        case .searchButtonClicked:
            guard let searchTerm = searchField.text else {
                return
            }
            viewModel.searchRepository(by: searchTerm)
        }
    }

    private func transitionToDetailView() {
        guard let detailViewController = storyboard?.instantiateViewController(withResource: R.storyboard.main.repositoryDetailViewController) else {
            return
        }

        detailViewController.repositories = viewModel.repositories
        detailViewController.lastSelectedItemIndexPath = viewModel.lastSelectedItemIndexPath
        detailViewController.delegate = self

        aTabBarController?.updateFloatingTabBarVisibility(false)
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    private func lastSelectedRepositoryCell() -> RepositoryCell? {
        collectionView.cellForItem(at: viewModel.lastSelectedItemIndexPath) as? RepositoryCell
    }

    private func scrollCellItem(to indexPath: IndexPath, animated: Bool) {
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: animated)
    }

    private func scrollTo(repository: RepositoryEntity, animated: Bool) {
        guard let indexPath = viewModel.indexPath(for: repository) else {
            return
        }

        // 遷移の時の sourceView を lastSelectedRepositoryCell() で返してるので lastSelectedItemIndexPath を更新する必要がある。
        // 副作用なのでここでするのは良くない。
        viewModel.lastSelectedItemIndexPath = indexPath
        scrollCellItem(to: indexPath, animated: animated)
    }
}

extension BookmarksViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.lastSelectedItemIndexPath = indexPath
        transitionToDetailView()
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (_) -> UIMenu? in

            let deleteAction = UIAction(title: R.string.localizable.deleteBookmark(), image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] (_) in
                self?.viewModel.deleteBookmark(at: indexPath)
            }

            return UIMenu(children: [deleteAction])
        }
    }
}

extension BookmarksViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems(in: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        configureCell(for: collectionView, at: indexPath) ?? RepositoryCell()
    }
}

extension BookmarksViewController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let isPresenting = toVC is RepositoryDetailViewController

        return RepositoryInfoViewAnimator(presenting: isPresenting)
    }
}

extension BookmarksViewController: TransitionSourceViewProvidable {

    var sourceViewFrameOffset: CGPoint {
        .zero
    }

    func sourceView(for animator: RepositoryInfoViewAnimator) -> UIView? {
        lastSelectedRepositoryCell()
    }
}

extension BookmarksViewController: RepositoryDetailViewControllerDelegate {

    func repositoryDetailViewController(_ detailViewController: RepositoryDetailViewController, willCloseWithVisible repository: RepositoryEntity) {
        scrollTo(repository: repository, animated: false)
        aTabBarController?.updateFloatingTabBarVisibility(true)
    }
}

extension BookmarksViewController: TabBarItemProvidable {

    var aTabBarItem: TabBarItem? {
        let bookmarkIcon = UIImage(systemName: "bookmark")
        assert(bookmarkIcon != nil, "bookmark is not exist in SF Symbols")

        return TabBarItem(icon: bookmarkIcon!, title: "Bookmark")
    }
}

extension BookmarksViewController: NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            collectionView.insertItems(at: [newIndexPath!])

        case .delete:
            collectionView.deleteItems(at: [indexPath!])

        case .update:
            collectionView.reloadItems(at: [indexPath!])

        case .move:
            collectionView.moveItem(at: indexPath!, to: newIndexPath!)

        @unknown default:
            fatalError("Unknown default in \(#function)")
        }
    }
}

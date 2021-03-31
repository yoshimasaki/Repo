//
//  SearchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import Combine

final class SearchViewController: UIViewController {

    private let searchField = SearchField(frame: .zero)

    private let viewModel = SearchViewModel()
    private var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        configureConstraints()
        subscribeState()
        subscribeError()
        subscribeSearchFieldText()
        subscribeSearchFieldState()
    }

    // MARK: - Configure Views
    private func configureViews() {
        searchField.placeholder = R.string.localizable.searchGitHubRepository()
    }

    private func configureConstraints() {
        searchField.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(searchField)

        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24)
        ])
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

    private func subscribeError() {
        viewModel.$error
            .sink { (error) in
                print(error?.errorDescription ?? "")
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

    private func handleState(_ state: SearchViewModelState) {
        switch state {
        case .none:
            break

        case .repositoriesUpdated:
            break
        }
    }

    private func handleSearchFieldTextDidChange(_ searchText: String?) {
        viewModel.cancelSearch()
    }

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
}

//
//  SearchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import Combine

final class SearchViewController: UITableViewController {

    private enum Constants {
        enum Segue {
            static let showRepositoryDetailViewController = "showRepositoryDetailViewController"
        }
    }

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? RepositoryDetailViewController, segue.identifier == Constants.Segue.showRepositoryDetailViewController else {
            return
        }

        detailViewController.repository = viewModel.lastSelectedRepository
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.repositories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        configureCell(for: tableView, at: indexPath)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // tableView の行をタップした時に呼ばれる
        viewModel.lastSelectedRowIndex = indexPath.row
        performSegue(withIdentifier: Constants.Segue.showRepositoryDetailViewController, sender: self)
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

    private func configureCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.repositoryCell, for: indexPath) else {
            fatalError("\(R.reuseIdentifier.repositoryCell) setup is incorrect")
        }

        let repository = viewModel.repositories[indexPath.row]
        cell.textLabel?.text = repository.fullName
        cell.detailTextLabel?.text = repository.language

        return cell
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
            tableView.reloadData()
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

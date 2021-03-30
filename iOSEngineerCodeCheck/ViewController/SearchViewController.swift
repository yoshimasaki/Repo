//
//  SearchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class SearchViewController: UITableViewController {

    private enum Constants {
        enum Segue {
            static let showRepositoryDetailViewController = "showRepositoryDetailViewController"
        }
    }

    @IBOutlet private weak var searchBar: UISearchBar!

    private let viewModel = SearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
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
        searchBar.placeholder = R.string.localizable.searchGitHubRepository()
        searchBar.delegate = self
    }

    private func configureCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.repositoryCell, for: indexPath) else {
            fatalError("\(R.reuseIdentifier.repositoryCell) setup is incorrect")
        }

        let repository = viewModel.repositories[indexPath.row]
        cell.textLabel?.text = repository["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = repository["language"] as? String ?? ""

        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.cancelSearch()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else {
            return
        }

        viewModel.searchRepository(by: searchTerm) { [weak self] result in
            switch result {
            case .failure(let error as LocalizedError):
                print(error.errorDescription ?? "")

            case .success:
                self?.tableView.reloadData()
            }
        }
    }
}

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

    private var repositories: [[String: Any]] = []

    private var searchSessionDataTask: URLSessionTask?
    private var lastSelectedRowIndex = 0

    private var lastSelectedRepository: [String: Any] {
        repositories[lastSelectedRowIndex]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? RepositoryDetailViewController, segue.identifier == Constants.Segue.showRepositoryDetailViewController else {
            return
        }

        detailViewController.repository = lastSelectedRepository
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repositories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        configureCell(for: tableView, at: indexPath)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // tableView の行をタップした時に呼ばれる
        lastSelectedRowIndex = indexPath.row
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

        let repository = repositories[indexPath.row]
        cell.textLabel?.text = repository["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = repository["language"] as? String ?? ""
        
        return cell
    }

    // MARK: - Search Reposotory
    private func searchRepository(by searchTerm: String) {
        guard !searchTerm.isEmpty else {
            return
        }

        do {
            let searchApiUrl = try GitHubApi.searchUrl(with: searchTerm)

            searchSessionDataTask = URLSession.shared.dataTask(with: searchApiUrl) { [weak self] (data, _, error) in

                guard let weakSelf = self else {
                    return
                }

                if let error = error {
                    // TODO: show network error to user
                    print("Faild to fetch search repository - error: \(error.localizedDescription)")
                    return
                }

                guard let repositories = weakSelf.repositories(from: data!) else {
                    return
                }

                weakSelf.repositories = repositories
                DispatchQueue.main.async {
                    weakSelf.tableView.reloadData()
                }
            }

            searchSessionDataTask!.resume()
        } catch {
            print("Cannot make url from \(searchTerm)")
        }
    }

    private func repositories(from data: Data) -> [[String: Any]]? {
        do {
            if
                let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                let items = jsonObject["items"] as? [[String: Any]]
            {
                return items
            }
        } catch {
            print("Failed to decode JSON data - error: \(error.localizedDescription)")
            return nil
        }

        return nil
    }
}

extension SearchViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchSessionDataTask?.cancel()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else {
            return
        }

        searchRepository(by: searchTerm)
    }
}

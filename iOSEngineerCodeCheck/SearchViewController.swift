//
//  SearchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!

    var repositories: [[String: Any]] = []

    var searchSessionDataTask: URLSessionTask?
    var lastSelectedRowIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.placeholder = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? RepositoryDetailViewController, segue.identifier == "Detail" else {
            return
        }

        detailViewController.searchViewController = self
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell()
        let repository = repositories[indexPath.row]
        cell.textLabel?.text = repository["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = repository["language"] as? String ?? ""
        cell.tag = indexPath.row
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移時に呼ばれる
        lastSelectedRowIndex = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }

    // MARK: - Search Reposotory
    private func searchRepository(by searchTerm: String) {
        guard !searchTerm.isEmpty else {
            return
        }

        let searchApiUrlString = "https://api.github.com/search/repositories?q=\(searchTerm)"
        guard let searchApiUrl = URL(string: searchApiUrlString) else {
            print("Cannot make url from \(searchApiUrlString)")
            return
        }

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

        // dataTask の実行
        searchSessionDataTask!.resume()
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

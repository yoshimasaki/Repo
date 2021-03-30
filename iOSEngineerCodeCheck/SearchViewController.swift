//
//  SearchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!

    var repositories: [[String: Any]]=[]

    var searchSessionDataTask: URLSessionTask?
    var searchTerm: String!
    var searchApiUrl: String!
    var lastSelectedRowIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // ↓こうすれば初期のテキストを消せる
        searchBar.text = ""
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchSessionDataTask?.cancel()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        searchTerm = searchBar.text!

        if searchTerm.count != 0 {
            searchApiUrl = "https://api.github.com/search/repositories?q=\(searchTerm!)"
            searchSessionDataTask = URLSession.shared.dataTask(with: URL(string: searchApiUrl)!) { (data, response, error) in
                if let jsonObject = try! JSONSerialization.jsonObject(with: data!) as? [String: Any] {
                    if let items = jsonObject["items"] as? [[String: Any]] {
                        self.repositories = items
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            // これ呼ばなきゃリストが更新されません
            searchSessionDataTask?.resume()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "Detail"{
            let detailViewController = segue.destination as! RepositoryDetailViewController
            detailViewController.searchViewController = self
        }
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
}

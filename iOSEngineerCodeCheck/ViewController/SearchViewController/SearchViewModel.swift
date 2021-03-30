//
//  SearchViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/03/30.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

final class SearchViewModel {
    @Published var state: SearchViewModelState = .none
    @Published var error: SearchViewModelError?

    private(set) var repositories: [[String: Any]] = []

    private var searchSessionDataTask: URLSessionTask?
    var lastSelectedRowIndex = 0

    var lastSelectedRepository: [String: Any] {
        repositories[lastSelectedRowIndex]
    }

    // MARK: - Search Reposotory
    func searchRepository(by searchTerm: String) {
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
                    weakSelf.error = .faildFetch(error: error)
                    return
                }

                guard let repositories = weakSelf.repositories(from: data!) else {
                    return
                }

                weakSelf.repositories = repositories
                weakSelf.state = .repositoriesUpdated
            }

            searchSessionDataTask!.resume()
        } catch {
            self.error = .cannotMakeUrl(urlString: searchTerm)
        }
    }

    func cancelSearch() {
        searchSessionDataTask?.cancel()
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

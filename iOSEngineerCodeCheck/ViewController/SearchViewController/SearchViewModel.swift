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

    private(set) var repositories: [RepositoryEntity] = []

    private var searchSessionDataTask: URLSessionTask?
    var lastSelectedRowIndex = 0

    var lastSelectedRepository: RepositoryEntity {
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

                do {
                    let repositories = try weakSelf.repositories(from: data!)

                    weakSelf.repositories = repositories
                    weakSelf.state = .repositoriesUpdated
                } catch {
                    weakSelf.error = .jsonDecodeError(error: error)
                }
            }

            searchSessionDataTask!.resume()
        } catch {
            self.error = .cannotMakeUrl(urlString: searchTerm)
        }
    }

    func cancelSearch() {
        searchSessionDataTask?.cancel()
    }

    private func repositories(from data: Data) throws -> [RepositoryEntity] {
        let result = try JSONDecoder.decoder.decode(SearchResultEntity.self, from: data)

        return result.items
    }
}

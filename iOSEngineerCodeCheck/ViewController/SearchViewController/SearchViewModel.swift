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

    private let apiClient: GitHubApiClient

    private(set) var repositories: [RepositoryEntity] = []

    private var searchSessionDataTask: URLSessionTask?
    var lastSelectedItemIndexPath: IndexPath = .init()

    var lastSelectedRepository: RepositoryEntity {
        repositories[lastSelectedItemIndexPath.item]
    }

    init(apiClient: GitHubApiClient = GitHubApiClient()) {
        self.apiClient = apiClient
    }

    // MARK: - Search Reposotory
    func searchRepository(by searchTerm: String) {
        state = .loading
        apiClient.searchRepository(by: searchTerm) { [weak self] (result) in
            guard let weakSelf = self else {
                return
            }

            weakSelf.state = .loaded

            switch result {
            case .failure(let error):
                weakSelf.error = weakSelf.searchViewModelError(with: error)

            case .success(let repositories):
                weakSelf.repositories = repositories
                weakSelf.state = .repositoriesUpdated
            }
        }
    }

    func cancelSearch() {
        apiClient.cancel()
    }

    private func searchViewModelError(with error: GitHubApiClientError) -> SearchViewModelError {
        switch error {
        case .cannotMakeSearchUrl(searchTerm: let searchTerm):
            return .cannotMakeUrl(urlString: searchTerm)

        case .cannotMakeReadmeUrl:
            fatalError("We didn't fetch readme in here, so never reach")

        case .faildFetch(error: let error):
            return .faildFetch(error: error)

        case .invalidHttpStatus(statusCode: let statusCode):
            return .invalidHttpStatus(statusCode: statusCode)

        case .jsonDecodeError(error: let error):
            return .jsonDecodeError(error: error)
        }
    }
}

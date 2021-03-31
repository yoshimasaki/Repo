//
//  GitHubApiClient.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/03/31.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

struct GitHubApiClient {

    let fetcher: URLFetchable

    init(fetcher: URLFetchable = URLFetcher()) {
        self.fetcher = fetcher
    }

    func searchUrl(with searchTerm: String) throws -> URL {
        guard let urlString = (gitHubSearchApiUrlBaseString + searchTerm).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw GitHubApiClientError.cannotMakeUrl(searchTerm: searchTerm)
        }

        guard let url = URL(string: urlString) else {
            throw GitHubApiClientError.cannotMakeUrl(searchTerm: searchTerm)
        }

        return url
    }

    func searchRepository(by searchTerm: String, completion: ((Result<[RepositoryEntity], GitHubApiClientError>) -> Void)?) {
        guard !searchTerm.isEmpty else {
            return
        }

        do {
            let searchApiUrl = try searchUrl(with: searchTerm)

            fetcher.fetch(url: searchApiUrl) { (data, response, error) in

                if let error = error {
                    completion?(.failure(.faildFetch(error: error)))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Failed to get HTTPURLResponse - response: \(response!)")
                    return
                }

                guard httpResponse.isStatusOk else {
                    completion?(.failure(.invalidHttpStatus(statusCode: httpResponse.statusCode)))
                    return
                }

                do {
                    let repositories = try self.repositories(from: data!)

                    completion?(.success(repositories))
                } catch {
                    completion?(.failure(.jsonDecodeError(error: error)))
                }
            }
        } catch {
            completion?(.failure(.cannotMakeUrl(searchTerm: searchTerm)))
        }
    }

    func cancel() {
        fetcher.cancelFetch()
    }

    private let gitHubSearchApiUrlBaseString = "https://api.github.com/search/repositories?q="

    private func repositories(from data: Data) throws -> [RepositoryEntity] {
        let result = try JSONDecoder.decoder.decode(SearchResultEntity.self, from: data)

        return result.items
    }
}

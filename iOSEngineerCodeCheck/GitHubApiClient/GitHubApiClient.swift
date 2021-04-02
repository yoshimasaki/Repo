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
            throw GitHubApiClientError.cannotMakeSearchUrl(searchTerm: searchTerm)
        }

        guard let url = URL(string: urlString) else {
            throw GitHubApiClientError.cannotMakeSearchUrl(searchTerm: searchTerm)
        }

        return url
    }

    func readmeUrl(with repository: RepositoryEntity) throws -> URL {
        guard
            let owner = repository.owner.login,
            let repositoryName = repository.name
        else {
            throw GitHubApiClientError.cannotMakeReadmeUrl(repository: repository)
        }

        let urlString = String(format: gitHubReadmeApiUrlBaseString, owner, repositoryName)

        guard let url = URL(string: urlString) else {
            throw GitHubApiClientError.cannotMakeReadmeUrl(repository: repository)
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
            completion?(.failure(.cannotMakeSearchUrl(searchTerm: searchTerm)))
        }
    }

    func readme(for repository: RepositoryEntity, completion: ((Result<ReadmeEntity, GitHubApiClientError>) -> Void)?) {
        do {
            let readmeUrl = try self.readmeUrl(with: repository)

            fetcher.fetch(url: readmeUrl) { (data, response, error) in
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
                    let readme = try self.readme(from: data!)

                    completion?(.success(readme))
                } catch {
                    completion?(.failure(.jsonDecodeError(error: error)))
                }
            }

        } catch is GitHubApiClientError {
            completion?(.failure(.cannotMakeReadmeUrl(repository: repository)))
        } catch {
            fatalError("Never reach here")
        }
    }

    func cancel() {
        fetcher.cancelFetch()
    }

    private let gitHubSearchApiUrlBaseString = "https://api.github.com/search/repositories?q="

    private let gitHubReadmeApiUrlBaseString = "https://api.github.com/repos/%@/%@/readme"

    private func repositories(from data: Data) throws -> [RepositoryEntity] {
        let result = try JSONDecoder.decoder.decode(SearchResultEntity.self, from: data)

        return result.items
    }

    private func readme(from data: Data) throws -> ReadmeEntity {
        try JSONDecoder.decoder.decode(ReadmeEntity.self, from: data)
    }
}

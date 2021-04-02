//
//  GitHubReadmePublisher.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/01.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation
import Combine

typealias ReadmeInfo = (fileName: String, contents: String)

enum GitHubReadmePublisher {

    static func readmePublisher(for repository: RepositoryEntity) -> AnyPublisher<ReadmeInfo?, Never> {
        let client = GitHubApiClient()

        let future: Future<ReadmeEntity?, Never> = Future { (promise) in
            client.readme(for: repository) { (result) in
                switch result {
                case .failure(let error):
                    print("Fetching README failed - error: \(error)")
                    promise(.success(nil))

                case .success(let readmeEntity):
                    promise(.success(readmeEntity))
                }
            }
        }

        let publisher = future
            .flatMap { (readmeEntity) -> AnyPublisher<ReadmeInfo?, Never> in
                guard let aReadmeEntity = readmeEntity else {
                    return Just(nil).eraseToAnyPublisher()
                }

                return fetchRemoteReadme(readmeEntity: aReadmeEntity)
            }

        return publisher.eraseToAnyPublisher()
    }

    private static func fetchRemoteReadme(readmeEntity: ReadmeEntity) -> AnyPublisher<ReadmeInfo?, Never> {
        guard let url = URL(string: readmeEntity.downloadUrl ?? "") else {
            return Just(nil).eraseToAnyPublisher()
        }

        let dataTaskPublisher = URLSession.shared.dataTaskPublisher(for: URLRequest.urlRequest(with: url))
            .catch({ _ in Empty<URLSession.DataTaskPublisher.Output, Never>() })
            .map({ (data, _) -> ReadmeInfo? in
                guard
                    let content = String(data: data, encoding: .utf8),
                    let fileName = readmeEntity.name
                else {
                    return nil
                }

                return (fileName, content)
            })

        return dataTaskPublisher.eraseToAnyPublisher()
    }
}

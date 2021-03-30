//
//  RepositoryDetailViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/03/30.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

final class RepositoryDetailViewModel {

    var repository: RepositoryEntity?

    var repositoryName: String {
        repository?.fullName ?? ""
    }

    var languageText: String {
        "Written in \(repository?.language ?? "")"
    }

    var starCountText: String {
        "\(repository?.stargazersCount ?? 0) stars"
    }

    var watchCountText: String {
        "\(repository?.watchersCount ?? 0) watchers"
    }

    var forkCountText: String {
        "\(repository?.forksCount ?? 0) forks"
    }

    var openIssueCount: String {
        "\(repository?.openIssuesCount ?? 0) open issues"
    }

    func fetchAvatarImage(completion: ((Result<UIImage?, RepositoryDetailViewModelError>) -> Void)?) {
        if
            let owner = repository?.owner,
            let avatarImageUrlString = owner.avatarUrl
        {
            guard let avatarImageUrl = URL(string: avatarImageUrlString) else {
                completion?(.failure(.cannotMakeUrl(urlString: avatarImageUrlString)))
                return
            }

            let dataTask = URLSession.shared.dataTask(with: avatarImageUrl) { (data, response, error) in

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

                let image = UIImage(data: data!)
                DispatchQueue.main.async {
                    completion?(.success(image))
                }
            }
            dataTask.resume()
        }
    }
}

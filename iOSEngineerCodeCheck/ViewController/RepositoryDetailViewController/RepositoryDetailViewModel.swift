//
//  RepositoryDetailViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/03/30.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

final class RepositoryDetailViewModel {

    var repository: [String: Any] = [:]

    var repositoryName: String {
        repository["full_name"] as? String ?? ""
    }

    var languageText: String {
        "Written in \(repository["language"] as? String ?? "")"
    }

    var starCountText: String {
        "\(repository["stargazers_count"] as? Int ?? 0) stars"
    }

    var watchCountText: String {
        "\(repository["watchers_count"] as? Int ?? 0) watchers"
    }

    var forkCountText: String {
        "\(repository["forks_count"] as? Int ?? 0) forks"
    }

    var openIssueCount: String {
        "\(repository["open_issues_count"] as? Int ?? 0) open issues"
    }

    func fetchAvatarImage(completion: ((Result<UIImage?, RepositoryDetailViewModelError>) -> Void)?) {
        if
            let owner = repository["owner"] as? [String: Any],
            let avatarImageUrlString = owner["avatar_url"] as? String
        {
            guard let avatarImageUrl = URL(string: avatarImageUrlString) else {
                completion?(.failure(.cannotMakeUrl(urlString: avatarImageUrlString)))
                return
            }

            let dataTask = URLSession.shared.dataTask(with: avatarImageUrl) { (data, _, error) in

                if let error = error {
                    completion?(.failure(.faildFetch(error: error)))
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

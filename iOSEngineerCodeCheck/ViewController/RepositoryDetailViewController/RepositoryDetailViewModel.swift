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

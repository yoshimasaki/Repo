//
//  RepositoryDetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositoryDetailViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var watchCountLabel: UILabel!
    @IBOutlet weak var forkCountLabel: UILabel!
    @IBOutlet weak var openIssueCountLabel: UILabel!

    var repository: [String: Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        languageLabel.text = "Written in \(repository["language"] as? String ?? "")"
        starCountLabel.text = "\(repository["stargazers_count"] as? Int ?? 0) stars"
        watchCountLabel.text = "\(repository["wachers_count"] as? Int ?? 0) watchers"
        forkCountLabel.text = "\(repository["forks_count"] as? Int ?? 0) forks"
        openIssueCountLabel.text = "\(repository["open_issues_count"] as? Int ?? 0) open issues"
        fetchAvatarImage()
    }

    func fetchAvatarImage() {
        repositoryNameLabel.text = repository["full_name"] as? String
        
        if
            let owner = repository["owner"] as? [String: Any],
            let avatarImageUrlString = owner["avatar_url"] as? String
        {
            guard let avatarImageUrl = URL(string: avatarImageUrlString) else {
                print("Cannot make avatar image URL from \(avatarImageUrlString)")
                return
            }

            let dataTask = URLSession.shared.dataTask(with: avatarImageUrl) { (data, _, error) in

                if let error = error {
                    print("Faild to fetch avatar image - error: \(error.localizedDescription)")
                    return
                }

                let image = UIImage(data: data!)
                DispatchQueue.main.async {
                    self.avatarImageView.image = image
                }
            }
            dataTask.resume()
        }
    }
}

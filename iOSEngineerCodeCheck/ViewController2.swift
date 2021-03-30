//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var watchCountLabel: UILabel!
    @IBOutlet weak var forkCountLabel: UILabel!
    @IBOutlet weak var openIssueCountLabel: UILabel!

    var searchViewController: ViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        let repository = searchViewController.repositories[searchViewController.lastSelectedRowIndex]

        languageLabel.text = "Written in \(repository["language"] as? String ?? "")"
        starCountLabel.text = "\(repository["stargazers_count"] as? Int ?? 0) stars"
        watchCountLabel.text = "\(repository["wachers_count"] as? Int ?? 0) watchers"
        forkCountLabel.text = "\(repository["forks_count"] as? Int ?? 0) forks"
        openIssueCountLabel.text = "\(repository["open_issues_count"] as? Int ?? 0) open issues"
        fetchAvatarImage()
    }

    func fetchAvatarImage() {

        let repository = searchViewController.repositories[searchViewController.lastSelectedRowIndex]

        repositoryNameLabel.text = repository["full_name"] as? String

        if let owner = repository["owner"] as? [String: Any] {
            if let avatarImageUrl = owner["avatar_url"] as? String {
                URLSession.shared.dataTask(with: URL(string: avatarImageUrl)!) { (data, res, err) in
                    let image = UIImage(data: data!)!
                    DispatchQueue.main.async {
                        self.avatarImageView.image = image
                    }
                }.resume()
            }
        }
    }
}

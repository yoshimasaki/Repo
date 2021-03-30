//
//  RepositoryDetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class RepositoryDetailViewController: UIViewController {

    var repository: [String: Any] {
        get {
            viewModel.repository
        }
        set {
            viewModel.repository = newValue
        }
    }

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var repositoryNameLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var starCountLabel: UILabel!
    @IBOutlet private weak var watchCountLabel: UILabel!
    @IBOutlet private weak var forkCountLabel: UILabel!
    @IBOutlet private weak var openIssueCountLabel: UILabel!

    private let viewModel = RepositoryDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        fetchAvatarImage()
    }

    private func configureViews() {
        repositoryNameLabel.text = repository["full_name"] as? String
        languageLabel.text = "Written in \(repository["language"] as? String ?? "")"
        starCountLabel.text = "\(repository["stargazers_count"] as? Int ?? 0) stars"
        watchCountLabel.text = "\(repository["watchers_count"] as? Int ?? 0) watchers"
        forkCountLabel.text = "\(repository["forks_count"] as? Int ?? 0) forks"
        openIssueCountLabel.text = "\(repository["open_issues_count"] as? Int ?? 0) open issues"
    }

    private func fetchAvatarImage() {
        viewModel.fetchAvatarImage { [weak self] (result) in
            switch result {
            case .failure(let error as LocalizedError):
                print(error.errorDescription ?? "")

            case .success(let image):
                self?.avatarImageView.image = image
            }
        }
    }
}

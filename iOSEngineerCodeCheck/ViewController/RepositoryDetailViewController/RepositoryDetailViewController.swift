//
//  RepositoryDetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class RepositoryDetailViewController: UIViewController {

    var repository: RepositoryEntity? {
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
        repositoryNameLabel.text = viewModel.repositoryName
        languageLabel.text = viewModel.languageText
        starCountLabel.text = viewModel.starCountText
        watchCountLabel.text = viewModel.watchCountText
        forkCountLabel.text = viewModel.forkCountText
        openIssueCountLabel.text = viewModel.openIssueCount
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

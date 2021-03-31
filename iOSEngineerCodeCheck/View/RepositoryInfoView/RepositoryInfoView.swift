//
//  RepositoryInfoView.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/03/31.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit
import Combine

final class RepositoryInfoView: UIView {

    var avatarImagePublisher: AnyPublisher<UIImage?, Never>? {
        didSet {
            subscribeAvatarImage()
        }
    }

    let avatarImageView = UIImageView(frame: .zero)
    let repositoryNameLabel = UILabel(frame: .zero)
    let descriptionLabel = UILabel(frame: .zero)

    let starStatusView = StatusValueView(frame: .zero)
    let watchStatusView = StatusValueView(frame: .zero)
    let forkStatusView = StatusValueView(frame: .zero)
    let openIssueStatusView = StatusValueView(frame: .zero)
    let languageStatusView = StatusValueView(frame: .zero)

    private lazy var statusStackView: UIStackView = {
        UIStackView(arrangedSubviews: [
            starStatusView,
            watchStatusView,
            forkStatusView,
            openIssueStatusView
        ])
    }()

    private var avatarImageSubscription: AnyCancellable?

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureViews()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureViews() {
        layer.cornerRadius = 20
        layer.cornerCurve = .continuous

        avatarImageView.layer.cornerRadius = 10
        avatarImageView.layer.cornerCurve = .continuous
        avatarImageView.clipsToBounds = true

        repositoryNameLabel.font = UIFont.systemFont(ofSize: 24)
        descriptionLabel.font = UIFont.systemFont(ofSize: 20)
        descriptionLabel.numberOfLines = 2

        statusStackView.axis = .horizontal
        statusStackView.spacing = 4
        statusStackView.alignment = .leading
        statusStackView.distribution = .fillProportionally

        let starImage = UIImage(systemName: "star")
        let watchImage = UIImage(systemName: "eye")
        // TODO: replace fork asset icon
        let forkImage = UIImage(systemName: "star")
        let openIssueImage = UIImage(systemName: "exclamationmark.circle")
        let languageImage = UIImage(systemName: "circlebadge.fill")

        assert(starImage != nil, "star is not exist in SF Symbols")
        assert(watchImage != nil, "eye is not exist in SF Symbols")
        assert(forkImage != nil, "fork image is not exist in assets")
        assert(openIssueImage != nil, "open issue is not exist in SF Symbols")
        assert(languageImage != nil, "language is not exist in SF Symbols")

        starStatusView.iconView.image = starImage
        watchStatusView.iconView.image = watchImage
        forkStatusView.iconView.image = forkImage
        openIssueStatusView.iconView.image = openIssueImage
        languageStatusView.iconView.image = languageImage

        backgroundColor = .systemBackground

        layer.shadowOpacity = 0.1
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
    }

    private func configureConstraints() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        repositoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        languageStatusView.translatesAutoresizingMaskIntoConstraints = false
        statusStackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(avatarImageView)
        addSubview(repositoryNameLabel)
        addSubview(descriptionLabel)
        addSubview(languageStatusView)
        addSubview(statusStackView)

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 30),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

            repositoryNameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            repositoryNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            repositoryNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: repositoryNameLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: repositoryNameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: repositoryNameLabel.trailingAnchor),

            languageStatusView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            languageStatusView.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            languageStatusView.trailingAnchor.constraint(equalTo: repositoryNameLabel.trailingAnchor),

            statusStackView.topAnchor.constraint(equalTo: languageStatusView.bottomAnchor, constant: 8),
            statusStackView.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            statusStackView.trailingAnchor.constraint(equalTo: repositoryNameLabel.trailingAnchor),
            statusStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    private func subscribeAvatarImage() {
        avatarImageSubscription?.cancel()

        guard let publisher = avatarImagePublisher else {
            avatarImageView.image = nil
            return
        }

        avatarImageSubscription = publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] (image) in
                self?.avatarImageView.image = image
            })
    }
}

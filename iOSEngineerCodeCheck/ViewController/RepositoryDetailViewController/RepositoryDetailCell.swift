//
//  RepositoryDetailCell.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/01.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

final class RepositoryDetailCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: RepositoryDetailCell.self)

    weak var delegate: RepositoryDetailCellDelegate?

    let repositoryInfoView = RepositoryInfoView(frame: .zero)
    let markdownCardView = MarkdownCardView(frame: .zero)
    private let closeButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureViews()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureViews() {
        let docIcon = UIImage(systemName: "doc.text")
        assert(docIcon != nil, "doc.text does not exist in SF Symbols")
        markdownCardView.iconView.image = docIcon
        markdownCardView.titleLabel.text = "README.md"

        closeButton.addTarget(self, action: #selector(handleCloseButtonTap(_:)), for: .touchUpInside)
        let closeIcon = UIImage(systemName: "xmark")
        assert(closeIcon != nil, "xmark does not exist in SF Symbols")
        closeButton.setImage(closeIcon, for: .normal)
        closeButton.backgroundColor = .systemBackground
        closeButton.tintColor = .systemGray
        closeButton.layer.cornerRadius = 20
        closeButton.layer.shadowOffset = .zero
        closeButton.layer.shadowRadius = 3
        closeButton.layer.shadowOpacity = 0.1
    }

    private func configureConstraints() {
        repositoryInfoView.translatesAutoresizingMaskIntoConstraints = false
        markdownCardView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(repositoryInfoView)
        contentView.addSubview(closeButton)
        contentView.addSubview(markdownCardView)

        NSLayoutConstraint.activate([
            repositoryInfoView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 24),
            repositoryInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            repositoryInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            repositoryInfoView.heightAnchor.constraint(equalToConstant: 180),

            closeButton.topAnchor.constraint(equalTo: repositoryInfoView.topAnchor, constant: -10),
            closeButton.trailingAnchor.constraint(equalTo: repositoryInfoView.trailingAnchor, constant: 10),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),

            markdownCardView.topAnchor.constraint(equalTo: repositoryInfoView.bottomAnchor, constant: 16),
            markdownCardView.leadingAnchor.constraint(equalTo: repositoryInfoView.leadingAnchor),
            markdownCardView.trailingAnchor.constraint(equalTo: repositoryInfoView.trailingAnchor),
            markdownCardView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }

    @objc private func handleCloseButtonTap(_ button: UIButton) {
        delegate?.repositoryDetailCellDidTapCloseButton(self)
    }
}
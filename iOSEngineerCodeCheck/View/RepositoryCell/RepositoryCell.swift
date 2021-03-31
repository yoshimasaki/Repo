//
//  RepositoryCell.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/03/31.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

final class RepositoryCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: RepositoryCell.self)

    let repositoryInfoView: RepositoryInfoView

    override init(frame: CGRect) {
        repositoryInfoView = RepositoryInfoView(frame: .zero)

        super.init(frame: frame)

        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureConstraints() {
        repositoryInfoView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(repositoryInfoView)

        NSLayoutConstraint.activate([
            repositoryInfoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            repositoryInfoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            repositoryInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            repositoryInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

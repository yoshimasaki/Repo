//
//  MarkdownCardView.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/01.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit
import MarkdownView

final class MarkdownCardView: UIView {

    let iconView = UIImageView(frame: .zero)
    let titleLabel = UILabel(frame: .zero)

    private var markdownView: MarkdownView?

    // この MarkdownCardView を角丸にしたいが clipToBounds = true にすると shadow までもクリップされてしまうので content だけを角丸にクリップする contentView が必要。
    private let contentView = UIView(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureViews()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadMarkdown(_ markdown: String) {
        markdownView?.removeFromSuperview()
        markdownView = nil

        let markdownView = MarkdownView()
        markdownView.load(markdown: markdown)

        self.markdownView = markdownView

        markdownView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(markdownView)

        NSLayoutConstraint.activate([
            markdownView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            markdownView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            markdownView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            markdownView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func configureViews() {
        backgroundColor = .systemBackground

        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.11
        layer.cornerRadius = 20
        layer.cornerCurve = .continuous

        contentView.layer.cornerRadius = 20
        contentView.layer.cornerCurve = .continuous
        contentView.clipsToBounds = true

        iconView.tintColor = .systemGray

        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = .systemGray
    }

    private func configureConstraints() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(contentView)
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),

            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor),

            titleLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
}

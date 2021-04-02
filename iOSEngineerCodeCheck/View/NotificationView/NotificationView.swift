//
//  NotificationView.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/02.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

final class NotificationView: UIView {

    private var notificationType: NotificationType = .messages

    private var messages: String? {
        didSet {
            messageLabel.text = messages
        }
    }

    private let messageLabel = UILabel(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: .zero)

        configureViews()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var bounds: CGRect {
        didSet {
            updateViewCornerRadius()
        }
    }

    func show(type: NotificationType = .messages, messages: String?, autoHideDelay: TimeInterval = 6, animated: Bool = true) {
        self.notificationType = type
        self.messages = messages
        updateStyles()
        isHidden = false
        transform = CGAffineTransform(translationX: .zero, y: -300)

        if animated {
            UIView.animate(withDuration: 0.3, delay: .zero, options: .curveEaseIn) {
                self.transform = .identity
            } completion: { (_) in
                self.autoHide(after: autoHideDelay)
            }
        } else {
            transform = .identity
            self.autoHide(after: autoHideDelay)
        }
    }

    func hide(animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.3, delay: .zero, options: .curveEaseIn) {
                self.transform = CGAffineTransform(translationX: .zero, y: -300)
            } completion: { (_) in
                self.isHidden = true
            }
        } else {
            transform = CGAffineTransform(translationX: .zero, y: -300)
        }
    }

    private func configureViews() {
        layer.cornerCurve = .continuous

        messageLabel.font = UIFont.systemFont(ofSize: 24)
    }

    private func configureConstraints() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(messageLabel)

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

    private func updateViewCornerRadius() {
        layer.cornerRadius = bounds.height * 0.5
    }

    private func updateStyles() {
        backgroundColor = notificationType.backgroundColor
        layer.shadowColor = notificationType.shadowColor?.cgColor
        messageLabel.textColor = notificationType.labelColor
    }

    private func autoHide(after delay: TimeInterval) {
        guard delay > 0 else {
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.hide()
        }
    }
}

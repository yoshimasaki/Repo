//
//  CircleButton.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/03.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

final class CircleButton: UIView {

    private enum ButtonScale {
        case normal, scaleDown, scaleUp

        var transform: CGAffineTransform {
            switch self {
            case .normal:
                return .identity

            case .scaleDown:
                return .init(scaleX: 0.8, y: 0.8)

            case .scaleUp:
                return .init(scaleX: 1.2, y: 1.2)
            }
        }
    }

    var tapAction: (() -> Void)?

    private let button = UIButton(frame: .zero)

    private let systemImageName: String
    private var buttonScale: ButtonScale = .normal
    private var buttonScaleAnimator: UIViewPropertyAnimator?

    private override init(frame: CGRect) {
        self.systemImageName = "star"

        super.init(frame: frame)

        configureViews()
        configureConstraints()
    }

    init(systemImageName: String) {
        self.systemImageName = systemImageName

        super.init(frame: .zero)

        configureViews()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureViews() {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 32)

        button.imageView?.tintColor = R.color.icon()
        button.backgroundColor = .systemBackground

        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 10

        button.layer.cornerRadius = 78 * 0.5
        button.layer.cornerCurve = .continuous

        button.setPreferredSymbolConfiguration(symbolConfiguration, forImageIn: .normal)

        configureButtonIcon(systemImageName: systemImageName)

        button.addTarget(self, action: #selector(handleButtonTap(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(handleButtonTapDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(handleButtonDragEnter(_:)), for: .touchDragEnter)
        button.addTarget(self, action: #selector(handleButtonDragExit(_:)), for: .touchDragExit)
    }

    private func configureConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false

        addSubview(button)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 78),
            heightAnchor.constraint(equalTo: widthAnchor),

            button.topAnchor.constraint(equalTo: topAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func configureButtonIcon(systemImageName: String) {
        let icon = UIImage(systemName: systemImageName)
        assert(icon != nil, "\(systemImageName) is not exist in SF Symbols")
        button.setImage(icon, for: .normal)
    }

    private func scaleButton(animated: Bool = true) {
        if animated {
            buttonScaleAnimator = {
                let a = UIViewPropertyAnimator(duration: 0.15, curve: .easeIn) { [weak self] in
                    self?.updateButtonScale()
                }

                let scale = buttonScale
                a.addCompletion { [weak self] (_) in
                    guard self?.buttonScale != scale else {
                        return
                    }

                    UIViewPropertyAnimator(duration: 0.15, curve: .easeIn) { [weak self] in
                        self?.updateButtonScale()
                    }.startAnimation()
                }

                return a
            }()

            buttonScaleAnimator?.startAnimation()
        } else {
            updateButtonScale()
        }
    }

    private func updateButtonScale() {
        transform = buttonScale.transform
    }

    @objc private func handleButtonTap(_ button: UIButton) {
        if buttonScaleAnimator?.isRunning ?? false {
            buttonScale = .normal
        } else {
            buttonScale = .normal
            scaleButton()
        }
        tapAction?()
    }

    @objc private func handleButtonTapDown(_ button: UIButton) {
        buttonScale = .scaleDown
        scaleButton()
    }

    @objc private func handleButtonDragExit(_ button: UIButton) {
        buttonScale = .normal
        scaleButton()
    }

    @objc private func handleButtonDragEnter(_ button: UIButton) {
        buttonScale = .scaleDown
        scaleButton()
    }
}

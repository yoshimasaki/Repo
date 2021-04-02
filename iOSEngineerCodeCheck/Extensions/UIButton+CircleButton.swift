//
//  UIButton+CircleButton.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/02.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

extension UIButton {

    static func circleButton(systemImageName: String) -> UIButton {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 32)
        let icon = UIImage(systemName: systemImageName)
        assert(icon != nil, "\(systemImageName) is not exist in SF Symbols")

        let button = UIButton(frame: .zero)

        button.setImage(icon, for: .normal)
        button.imageView?.tintColor = R.color.icon()
        button.backgroundColor = .systemBackground

        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 10

        button.layer.cornerRadius = 78 * 0.5
        button.layer.cornerCurve = .continuous

        button.setPreferredSymbolConfiguration(symbolConfiguration, forImageIn: .normal)

        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 78),
            button.heightAnchor.constraint(equalTo: button.widthAnchor)
        ])

        return button
    }
}

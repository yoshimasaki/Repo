//
//  TabBar.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/02.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

final class TabBar: UIView {

    var items: [TabBarItem] = [] {
        didSet {
            updateTabBarItemButton(with: items)
        }
    }

    var selectedItemIndex = 0 {
        didSet {
            updateTabBarItemsTint()
        }
    }

    var itemTapAction: ((TabBarItem, Int) -> Void)?

    private lazy var itemStackView: UIStackView = {
        let buttons = items.enumerated().map { item -> UIButton in
            let button = makeItemButton(with: item.element)
            button.tag = item.offset

            return button
        }

        let stackView = UIStackView(arrangedSubviews: buttons)

        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

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

    private func configureViews() {
        backgroundColor = .systemBackground

        layer.shadowOpacity = 0.1
        layer.shadowOffset = .zero
        layer.shadowRadius = 10

        layer.cornerCurve = .continuous

        itemStackView.axis = .horizontal
        itemStackView.distribution = .fillEqually
        itemStackView.spacing = 8

        updateTabBarItemsTint()
    }

    private func configureConstraints() {
        itemStackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(itemStackView)

        NSLayoutConstraint.activate([
            itemStackView.topAnchor.constraint(equalTo: topAnchor),
            itemStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            itemStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            itemStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }

    private func makeItemButton(with item: TabBarItem) -> UIButton {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 32)
        let button = UIButton(frame: .zero)
        button.setImage(item.icon, for: .normal)
        button.imageView?.tintColor = item.tint
        button.setPreferredSymbolConfiguration(symbolConfiguration, forImageIn: .normal)
        button.addTarget(self, action: #selector(handleTabItemButtonTap(_:)), for: .touchUpInside)

        return button
    }

    private func updateTabBarItemButton(with items: [TabBarItem]) {
        let buttons = items.enumerated().map { item -> UIButton in
            let button = makeItemButton(with: item.element)
            button.tag = item.offset

            return button
        }

        itemStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        buttons.forEach { itemStackView.addArrangedSubview($0) }
        buttons.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        addTabItemButtonsConstraints(buttons: buttons)
        updateTabBarItemsTint()
    }

    private func addTabItemButtonsConstraints(buttons: [UIButton]) {
        let constraints = buttons.flatMap { tabItemButtonConstraints(buttons: $0) }
        NSLayoutConstraint.activate(constraints)
    }

    private func tabItemButtonConstraints(buttons: UIButton) -> [NSLayoutConstraint] {
        [buttons.heightAnchor.constraint(equalTo: itemStackView.heightAnchor)]
    }

    private func updateViewCornerRadius() {
        layer.cornerRadius = bounds.height * 0.5
    }

    private func updateTabBarItemsTint() {
        guard let buttons = itemStackView.arrangedSubviews as? [UIButton] else {
            return
        }

        buttons.enumerated().forEach { (item) in
            let tabItem = items[item.offset]
            item.element.imageView?.tintColor = item.offset == selectedItemIndex ? tabItem.tint : R.color.secondaryIcon()
        }
    }

    @objc private func handleTabItemButtonTap(_ button: UIButton) {
        let index = button.tag
        let item = items[index]

        selectedItemIndex = index
        itemTapAction?(item, index)
    }
}

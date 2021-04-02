//
//  TabBarController.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/02.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {

    let floatingTabBar = TabBar(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        configureConstraints()
        updateFloatingTabBarItems()
    }

    func updateFloatingTabBarVisibility(_ isVisible: Bool, animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.floatingTabBar.transform = isVisible ? .identity : CGAffineTransform(translationX: .zero, y: 200)
            }
        } else {
            self.floatingTabBar.transform = isVisible ? .identity : CGAffineTransform(translationX: .zero, y: 200)
        }
    }

    private func configureViews() {
        tabBar.isHidden = true

        floatingTabBar.itemTapAction = { [weak self] (item, tabIndex) in
            self?.handleFloatingTabBarItemTap(item: item, tabIndex: tabIndex)
        }
    }

    private func configureConstraints() {
        floatingTabBar.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(floatingTabBar)

        NSLayoutConstraint.activate([
            floatingTabBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // 横幅をタブアイテム2個を前提に固定している。今はレイアウトが可変長を扱えない。
            floatingTabBar.widthAnchor.constraint(equalToConstant: 190),
            floatingTabBar.heightAnchor.constraint(equalToConstant: 78),
            floatingTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
    }

    private func updateFloatingTabBarItems() {
        guard let itemProvidables = self.viewControllers as? [TabBarItemProvidable] else {
            return
        }

        floatingTabBar.items = itemProvidables.compactMap { $0.aTabBarItem }
    }

    private func handleFloatingTabBarItemTap(item: TabBarItem, tabIndex: Int) {
        selectedIndex = tabIndex
    }
}

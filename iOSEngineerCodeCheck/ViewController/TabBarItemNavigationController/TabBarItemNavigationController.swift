//
//  TabBarItemNavigationController.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/02.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

final class TabBarItemNavigationController: UINavigationController, TabBarItemProvidable {

    var aTabBarItem: TabBarItem? {
        (viewControllers.first as? TabBarItemProvidable)?.aTabBarItem
    }
}

//
//  TabBarItemProvidable.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/02.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

protocol TabBarItemProvidable: class {
    var aTabBarItem: TabBarItem? { get }
}

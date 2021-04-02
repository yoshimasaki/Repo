//
//  TabBarItem.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/02.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

struct TabBarItem: Hashable {
    let id = UUID()
    let icon: UIImage
    let title: String
    let tint: UIColor = UIColor(resource: R.color.icon)!
}

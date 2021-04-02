//
//  UIView+Snapshot.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/02.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

extension UIView {

    func snapshotLayer() -> UIImageView {
        let layerImage = UIGraphicsImageRenderer(bounds: bounds).image { (context) in
            layer.render(in: context.cgContext)
        }

        return UIImageView(image: layerImage)
    }
}

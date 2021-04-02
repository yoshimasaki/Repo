//
//  UIButton+TappedEffect.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/02.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

extension UIButton {

    func applyTappedEffect() {
        UIView.animateKeyframes(withDuration: 0.2, delay: .zero, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: .zero, relativeDuration: 0.5) {
                self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            }

            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 1.0) {
                self.transform = .identity
            }
        }, completion: nil)
    }
}

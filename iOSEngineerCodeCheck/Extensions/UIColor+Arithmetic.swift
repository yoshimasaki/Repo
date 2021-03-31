//
//  UIColor+Arithmetic.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/03/31.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

extension UIColor {

    func multiply(red: CGFloat = 1, green: CGFloat = 1, blue: CGFloat = 1, alpha: CGFloat = 1) -> UIColor {
        var r: CGFloat = .zero
        var g: CGFloat = .zero
        var b: CGFloat = .zero
        var a: CGFloat = .zero
        self.getRed(&r, green: &g, blue: &b, alpha: &a)

        return UIColor(red: r * red, green: g * green, blue: b * blue, alpha: a * alpha)
    }

    func add(red: CGFloat = 1, green: CGFloat = 1, blue: CGFloat = 1, alpha: CGFloat = 1) -> UIColor {
        var r: CGFloat = .zero
        var g: CGFloat = .zero
        var b: CGFloat = .zero
        var a: CGFloat = .zero
        self.getRed(&r, green: &g, blue: &b, alpha: &a)

        return UIColor(red: r + red, green: g + green, blue: b + blue, alpha: a + alpha)
    }

    func multiply(hue: CGFloat = 1, saturation: CGFloat = 1, brightness: CGFloat = 1, alpha: CGFloat = 1) -> UIColor {
        var h: CGFloat = .zero
        var s: CGFloat = .zero
        var b: CGFloat = .zero
        var a: CGFloat = .zero
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)

        return UIColor(hue: h * hue, saturation: s * saturation, brightness: b * brightness, alpha: a * alpha)
    }

    func add(hue: CGFloat = .zero, saturation: CGFloat = .zero, brightness: CGFloat = .zero, alpha: CGFloat = .zero) -> UIColor {
        var h: CGFloat = .zero
        var s: CGFloat = .zero
        var b: CGFloat = .zero
        var a: CGFloat = .zero
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)

        return UIColor(hue: h + hue, saturation: s + saturation, brightness: b + brightness, alpha: a + alpha)
    }

    func saturated(by value: CGFloat) -> UIColor {
        self.multiply(saturation: value)
    }
}

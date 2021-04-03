//
//  KeyboardPublisher.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/03.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit
import Combine

public enum KeyboardPublisher {

    public static let didShowPublisher: NotificationCenter.Publisher = {
        NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)
    }()

    public static let didHidePublisher: NotificationCenter.Publisher = {
        NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)
    }()

    public static let didChangeFramePublisher: NotificationCenter.Publisher = {
        NotificationCenter.default.publisher(for: UIResponder.keyboardDidChangeFrameNotification)
    }()

    public static let framePublisher: AnyPublisher<CGRect, Never> = {
        KeyboardPublisher.didShowPublisher
            .merge(with: KeyboardPublisher.didChangeFramePublisher)
            .map { $0.userInfo![UIResponder.keyboardFrameEndUserInfoKey]! as! CGRect }
            .eraseToAnyPublisher()
    }()

    public static let heightPublisher: AnyPublisher<CGFloat, Never> = {
        KeyboardPublisher.framePublisher
            .map { $0.height }
            .eraseToAnyPublisher()
    }()
}

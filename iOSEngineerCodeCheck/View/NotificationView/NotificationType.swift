//
//  NotificationType.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/02.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

enum NotificationType {
    case error, messages

    var backgroundColor: UIColor? {
        switch self {
        case .error:
            return R.color.error()

        case .messages:
            return .systemBackground
        }
    }

    var labelColor: UIColor? {
        switch self {
        case .error:
            return R.color.errorLabel()

        case .messages:
            return R.color.icon()
        }
    }

    var shadowColor: UIColor? {
        switch self {
        case .error:
            return R.color.error()

        case .messages:
            return .label
        }
    }
}

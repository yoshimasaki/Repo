//
//  SearchViewModelError.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/03/30.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

enum SearchViewModelError: LocalizedError {
    case faildFetch(error: Error)

    var errorDescription: String? {
        switch self {
        case .faildFetch(error: let error):
            return "Faild to fetch search repository - error: \(error.localizedDescription)"
        }
    }
}

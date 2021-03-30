//
//  SearchViewModelError.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/03/30.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

enum SearchViewModelError: LocalizedError {
    case cannotMakeUrl(urlString: String)
    case faildFetch(error: Error)
    case jsonDecodeError(error: Error)

    var errorDescription: String? {
        switch self {
        case .cannotMakeUrl(urlString: let urlString):
            return "Cannot make url from search term: \"\(urlString)\""

        case .faildFetch(error: let error):
            return "Faild to fetch search repository - error: \(error.localizedDescription)"

        case .jsonDecodeError(error: let error):
            return "Faild to decode JSON from data - error: \(error.localizedDescription)"
        }
    }
}

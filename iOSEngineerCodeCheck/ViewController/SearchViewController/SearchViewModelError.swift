//
//  SearchViewModelError.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/03/30.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

enum SearchViewModelError: LocalizedError, Equatable {
    case cannotMakeUrl(urlString: String)
    case faildFetch(error: Error)
    case invalidHttpStatus(statusCode: Int)
    case jsonDecodeError(error: Error)

    var errorDescription: String? {
        switch self {
        case .cannotMakeUrl(urlString: let urlString):
            return "Cannot make url from search term: \"\(urlString)\""

        case .faildFetch(error: let error):
            return "Faild to fetch search repository - error: \(error.localizedDescription)"

        case .invalidHttpStatus(statusCode: let statusCode):
            return "Invalid HTTP status code (\(statusCode)"

        case .jsonDecodeError(error: let error):
            return "Faild to decode JSON from data - error: \(error.localizedDescription)"
        }
    }

    static func == (lhs: SearchViewModelError, rhs: SearchViewModelError) -> Bool {
        switch (lhs, rhs) {
        case let (.cannotMakeUrl(lhsSearchTerm), .cannotMakeUrl(rhsSearchTerm)):
            return lhsSearchTerm == rhsSearchTerm

        case (.faildFetch, .faildFetch):
            return true

        case let (.invalidHttpStatus(lhsStatucCode), .invalidHttpStatus(rhsStatusCode)):
            return lhsStatucCode == rhsStatusCode

        case (.jsonDecodeError, .jsonDecodeError):
            return true

        default:
            return false
        }
    }
}

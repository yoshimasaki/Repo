//
//  GitHubApiClientError.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/03/31.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

enum GitHubApiClientError: LocalizedError, Equatable {

    case cannotMakeUrl(searchTerm: String)
    case faildFetch(error: Error)
    case invalidHttpStatus(statusCode: Int)
    case jsonDecodeError(error: Error)

    var errorDescription: String? {
        switch self {
        case .cannotMakeUrl(searchTerm: let searchTerm):
            return "Cannot make URL with \"\(searchTerm)\""

        case .faildFetch(error: let error):
            return "Faild to fetch search repository - error: \(error.localizedDescription)"

        case .invalidHttpStatus(statusCode: let statusCode):
            return "Invalid HTTP status code (\(statusCode)"

        case .jsonDecodeError(error: let error):
            return "Faild to decode JSON from data - error: \(error.localizedDescription)"
        }
    }

    static func == (lhs: GitHubApiClientError, rhs: GitHubApiClientError) -> Bool {
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

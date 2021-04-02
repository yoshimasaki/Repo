//
//  GitHubApiClientError.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/03/31.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

enum GitHubApiClientError: LocalizedError, Equatable {

    case cannotMakeSearchUrl(searchTerm: String)
    case cannotMakeReadmeUrl(repository: RepositoryEntity)
    case faildFetch(error: Error)
    case invalidHttpStatus(statusCode: Int)
    case jsonDecodeError(error: Error)

    var errorDescription: String? {
        switch self {
        case .cannotMakeSearchUrl(searchTerm: let searchTerm):
            return "Cannot make URL with \"\(searchTerm)\""

        case .cannotMakeReadmeUrl(repository: let repository):
            return "Cannot maek URL with \(repository)"

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
        case let (.cannotMakeSearchUrl(lhsSearchTerm), .cannotMakeSearchUrl(rhsSearchTerm)):
            return lhsSearchTerm == rhsSearchTerm

        case let (.cannotMakeReadmeUrl(lhsRepository), .cannotMakeReadmeUrl(rhsRepository)):
            return lhsRepository.fullName == rhsRepository.fullName

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

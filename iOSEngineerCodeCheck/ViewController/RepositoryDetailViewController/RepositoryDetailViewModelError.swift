//
//  RepositoryDetailViewModelError.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/03/30.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

enum RepositoryDetailViewModelError: LocalizedError {
    case cannotMakeUrl(urlString: String)
    case faildFetch(error: Error)
    case invalidHttpStatus(statusCode: Int)

    var errorDescription: String? {
        switch self {
        case .cannotMakeUrl(urlString: let urlString):
            return "Cannot make avatar image URL from \(urlString)"

        case .faildFetch(error: let error):
            return "Faild to fetch avatar image - error: \(error.localizedDescription)"

        case .invalidHttpStatus(statusCode: let statusCode):
            return "Invalid HTTP status code (\(statusCode)"
        }
    }
}

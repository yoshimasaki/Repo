//
//  GitHubApiError.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/03/30.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

enum GitHubApiError: Error {
    case cannotMakeUrl(searchTerm: String)
}

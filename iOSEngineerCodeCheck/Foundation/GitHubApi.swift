//
//  GitHubApi.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/03/30.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

enum GitHubApi {

    private static let gitHubSearchApiUrlBaseString = "https://api.github.com/search/repositories?q="

    static func searchUrl(with searchTerm: String) throws -> URL {
        let urlString = gitHubSearchApiUrlBaseString + searchTerm

        guard let url = URL(string: urlString) else {
            throw GitHubApiError.cannotMakeUrl(searchTerm: searchTerm)
        }

        return url
    }
}

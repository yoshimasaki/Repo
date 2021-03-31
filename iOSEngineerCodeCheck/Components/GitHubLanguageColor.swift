//
//  GitHubLanguageColor.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/03/31.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

final class GitHubLanguageColor {

    static let shared = GitHubLanguageColor()

    private lazy var colorsJson: [String: Any] = {
        guard let data = try? Data(resource: R.file.colorsJson) else {
            fatalError("Cannot load colorsJson file")
        }

        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            fatalError("Cannot decode json file")
        }

        return json
    }()

    func color(for language: String) -> UIColor {
        guard
            let object = colorsJson[language] as? [String: Any],
            let hex = object["color"] as? String, hex != "null"
        else {
            return .systemBackground
        }

        return UIColor(hexString: hex)
    }
}

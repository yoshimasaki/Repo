//
//  SearchHistoryEntryCell.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/03.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

final class SearchHistoryEntryCell: UITableViewCell {

    static let reuseIdentifier = String(describing: SearchHistoryEntryCell.self)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        configureViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureViews() {
        textLabel?.font = UIFont.systemFont(ofSize: 24)
        textLabel?.textColor = R.color.icon()
    }
}

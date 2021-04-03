//
//  SearchHistoryViewControllerDelegate.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/03.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

protocol SearchHistoryViewControllerDelegate: class {
    func searchHistoryViewController(_ searchHistoryViewController: SearchHistoryViewController, didSelect searchHistoryEntry: SearchHistoryEntry)
}

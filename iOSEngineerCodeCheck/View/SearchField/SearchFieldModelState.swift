//
//  SearchFieldModelState.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/03/31.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

enum SearchFieldModelState: Equatable {
    case none
    case updatePlaceholderHidden(Bool)
    case didBeginEditing
    case didEndEditing
}

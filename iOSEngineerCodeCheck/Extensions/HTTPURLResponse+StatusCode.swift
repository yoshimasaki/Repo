//
//  HTTPURLResponse+StatusCode.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/03/31.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import Foundation

extension HTTPURLResponse {

    var isStatusOk: Bool {
        statusCode == 200
    }
}

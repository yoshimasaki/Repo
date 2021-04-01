//
//  TransitionSourceViewProvidable.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/04/02.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

protocol TransitionSourceViewProvidable: class {
    var sourceViewFrameOffset: CGPoint { get }
    func sourceView(for animator: RepositoryInfoViewAnimator) -> UIView?
}

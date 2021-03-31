//
//  ImagePublisher.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshihisa Masaki on 2021/03/31.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit
import Combine

enum ImagePublisher {
    static func imagePublisher(url: URL) -> AnyPublisher<UIImage?, Never> {
        URLSession.shared.dataTaskPublisher(for: url)
            .catch({ _ in Empty() })
            .map({ (data, _) -> UIImage? in
                UIImage(data: data)
            })
            .eraseToAnyPublisher()
    }
}

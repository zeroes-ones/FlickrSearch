//
//  Navigator.swift
//  FlickrSearch
//
//  Created by S on 8/30/20.
//  Copyright © 2020 Sandeep. All rights reserved.
//

import Foundation
import UIKit

public typealias Presentable = UIViewController

public enum NavigationType {
    case push
    case present
}

protocol Navigator {
    associatedtype Destination
    init(
        root: Presentable?,
        destination: Destination,
        navigationType: NavigationType
    )
    func handle(error: Error)
}

extension Navigator {
    func handle(error: Error) { }
}

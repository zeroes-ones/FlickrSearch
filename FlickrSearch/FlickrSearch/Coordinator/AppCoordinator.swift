//
//  AppCoordinator.swift
//  FlickrSearch
//
//  Created by S on 8/30/20.
//  Copyright © 2020 Sandeep. All rights reserved.
//

import Foundation
import UIKit

/// Handle all app level resources
final class AppCoordinator {

    private let launchOptions: [UIApplication.LaunchOptionsKey: Any]?

    init(
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) {
        self.launchOptions = launchOptions
    }
}

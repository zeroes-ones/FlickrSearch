//
//  SceneCoordinator.swift
//  FlickrSearch
//
//  Created by S on 8/30/20.
//  Copyright © 2020 Sandeep. All rights reserved.
//

import Foundation
import UIKit

final class SceneCoordinator {

    private let window: UIWindow
    private let connectionOptions: UIScene.ConnectionOptions

    init(
        window: UIWindow,
        connectionOptions: UIScene.ConnectionOptions
    ) {
        self.window = window
        self.connectionOptions = connectionOptions
        let mainCoordinator =  MainCoordinator(destination: .flickrImageList(FlickrSearchViewModel(FlickrAPIManager())))
        mainCoordinator.start()
        window.rootViewController = mainCoordinator.navigationViewController
        window.makeKeyAndVisible()
    }
}

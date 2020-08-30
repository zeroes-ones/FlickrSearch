//
//  MainCoordinator.swift
//  FlickrSearch
//
//  Created by S on 8/30/20.
//  Copyright © 2020 Sandeep. All rights reserved.
//

import Foundation
import UIKit

struct MainCoordinator {
    private let navigator: PhotosNaviator

    var navigationViewController: UINavigationController? {
        navigator.navigationController
    }

    init(rootViewController: UIViewController? = nil, destination: Destination) {
        var navigator: PhotosNaviator {
            switch destination {
            case let .flickrImageList(searchModel):
                return PhotosNaviator(root: rootViewController, destination: .flickrImageList(searchModel), navigationType: .push)
            }
        }
        self.navigator = navigator
    }

    func start() {
        navigator.navigate()
    }
}

extension MainCoordinator {
    enum Destination {
        case flickrImageList(FlickrSearchViewModel)
    }
}

//
//  PhotosNavigator.swift
//  FlickrSearch
//
//  Created by S on 8/30/20.
//  Copyright © 2020 Sandeep. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

/// Navigator is an interface between viewcontrollers to navigate between different views(SwiftUI) and ViewControllers
final class PhotosNaviator: Navigator {
    private weak var rootViewController: UIViewController?
    private let destination: Destination
    private let navigationType: NavigationType
    private(set) weak var navigationController: UINavigationController?
    init(
        root: Presentable?,
        destination: Destination,
        navigationType: NavigationType
    ) {
        self.rootViewController = root
        self.destination = destination
        self.navigationType = navigationType
    }

    func popToRootView() {
        rootViewController?.navigationController?.popToRootViewController(animated: true)
    }

    func navigate() {
        navigate(to: destination, type: navigationType)
    }
}

extension PhotosNaviator {
    enum Destination {
        case flickrImageList(FlickrSearchViewModel)
        case photo(photo: Flickr.Photo, imageCache: ImageCache, fullScreen: Bool)
    }

    func navigate(
        to destination: Destination,
        type: NavigationType = .push
    ) {
        
    }
}

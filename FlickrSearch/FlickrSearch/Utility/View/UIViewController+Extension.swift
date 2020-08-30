//
//  UIViewController+Extension.swift
//  FlickrSearch
//
//  Created by S on 8/30/20.
//  Copyright © 2020 Sandeep. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    class func instantiateFromStoryboard(_ storyboardName: String, storyboardId: String, bundle: Bundle? = nil) -> Self {
        return instantiateFromStoryboardHelper(storyboardName, storyboardId: storyboardId, bundle: bundle)
    }

    fileprivate class func instantiateFromStoryboardHelper<T>(_ storyboardName: String, storyboardId: String?, bundle: Bundle? = nil) -> T {
           let storyboard = UIStoryboard(name: storyboardName, bundle: bundle ?? Bundle(for: self))
           switch storyboardId {
           case .some(let id):
               guard let controller = storyboard.instantiateViewController(withIdentifier: id) as? T else {
                   let message = "View controller of type \(T.self) does not exist in storyboard \(storyboardName) with identifier \(id)"
                   fatalError(message)
               }
               return controller
           case nil:
               guard let controller = storyboard.instantiateInitialViewController() as? T else {
                   let message = "View controller of type \(T.self) is not the initial view controller in storyboard \(storyboardName)"
                   fatalError(message)
               }
               return controller
           }
       }
}


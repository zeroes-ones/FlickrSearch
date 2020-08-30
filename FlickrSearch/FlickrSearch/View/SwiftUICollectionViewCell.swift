//
//  SwiftUICollectionViewCell.swift
//  FlickrSearch
//
//  Created by S on 8/30/20.
//  Copyright © 2020 Sandeep. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

/// Represents `UICollectionViewCell` with the given `Content` as SwiftUI view
public final class SwiftUICollectionViewCell<Content>: UICollectionViewCell where Content: View {
    private var hostingController: UIHostingController<Content>?
    private static var reuseIdentifier: String {
        "\(Content.self)"
    }

    /// Register a cell to collection view with reuse identifier.
    public static func register(with collectionView: UICollectionView) {
        collectionView.register(Self.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    /// Convenience method to dequeue a cell of a particular type.
    public static func dequeue(
        from collectionView: UICollectionView,
        for indexPath: IndexPath
    ) -> Self {
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! Self
    }

    /// Sets swiftui view as content view to the `UICollectionViewCell`
    public func setView(_ view: Content) {
        if let hostingController = hostingController {
            hostingController.rootView = view
        } else {
            let hostingController = UIHostingController<Content>(rootView: view)
            hostingController.view.backgroundColor = .clear
            contentView.addConstrainedSubview(hostingController.view, top: 0, bottom: 0, leading: 0, trailing: 0)
            self.hostingController = hostingController
        }
    }
}


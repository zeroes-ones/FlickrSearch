//
//  FlickrImageViewCell.swift
//  FlickrSearch
//
//  Created by S on 8/30/20.
//  Copyright © 2020 Sandeep. All rights reserved.
//

import Foundation
import SwiftUI

struct FlickrImageViewCell {
    let photo: Flickr.Photo
    var imageCache: ImageCache
    @State var isFullScreen = false
    private let imageSize: CGFloat = 120
    private let fullScreenImageSize: CGFloat = 400
    private let imageCornerRadius: CGFloat = 4
}

extension FlickrImageViewCell: View {
    var body: some View {
        ///from swift version >= 5.3, where opaque return types are supported.
        guard let url = photo.url else {
            return AnyView(
                ActivityIndicator(style: .medium, color: .red, isAnimating: true)
                .aspectRatio(contentMode: isFullScreen ? .fill : .fit)
                .scaledToFit()
                .frame(width: imageSize, height: imageSize)
            )
        }
        let urlImage = URLImage(url: url, cache: imageCache, placeholder: Image(systemName: "slowmo"), configuration: { $0.resizable() })
            .aspectRatio(contentMode: .fit)
            .frame(width: isFullScreen ? fullScreenImageSize : imageSize, height: isFullScreen ? fullScreenImageSize: imageSize)
            .cornerRadius(imageCornerRadius)
        return AnyView(urlImage)
    }
}

//
//  URLImage.swift
//  FlickrSearch
//
//  Created by S on 8/30/20.
//  Copyright © 2020 Sandeep. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct URLImage: SwiftUI.View {
    @ObservedObject private var imageLoader: ImageLoader
    private let placeholder: Image
    private let configuration: (Image) -> Image

    init(
        url: URL,
        cache: ImageCache? = nil,
        placeholder: Image,
        configuration: @escaping (Image) -> Image = { $0 }
    ) {
        self.placeholder = placeholder
        self.configuration = configuration
        self.imageLoader = ImageLoader(url: url, cache: cache)
    }

    var body: some SwiftUI.View {
        image
            .onAppear {
                self.imageLoader.load()
        }
        .onDisappear {
            self.imageLoader.cancel()
        }
    }

    private var image: some View {
        guard let image = imageLoader.image else {
            return placeholder
        }
        return configuration(Image(uiImage: image))
    }

}

private class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private var isLoading = false
    private var cancellable: AnyCancellable?
    private let url: URL
    private var cache: ImageCache?
    private static let imageLoaderQueue = DispatchQueue(label: "image-loader",
                                                        attributes: .concurrent)

    init(url: URL, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
        self.image = cache?[url]
        load()
    }

    func load() {
        guard !isLoading else { return }

        if let image = cache?[url] {
            self.image = image
            return
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                          receiveOutput: { [weak self] in self?.cache($0) },
                          receiveCompletion: { [weak self] _ in self?.onFinish() },
                          receiveCancel: { [weak self] in self?.onFinish() })
            .subscribe(on: Self.imageLoaderQueue)
            .assign(to: \.image, on: self)
    }

    func cancel() {
        cancellable?.cancel()
    }

    private func onStart() {
        isLoading = true
    }

    private func onFinish() {
        isLoading = false
    }

    private func cache(_ image: UIImage?) {
        image.map { cache?[url] = $0 }
    }
}

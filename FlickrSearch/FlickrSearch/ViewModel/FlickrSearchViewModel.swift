//
//  FlickrSearchViewModel.swift
//  FlickrSearch
//
//  Created by S on 8/30/20.
//  Copyright © 2020 Sandeep. All rights reserved.
//

import Foundation
import ReactiveSwift

struct FlickrSearchViewModel {

    let searchRequest: FlickrSearchRequest
    /// Improvement: we can handle the error in a different way to with `Result` too
    var photoList: MutableProperty<[Flickr.Photos]> = MutableProperty([])
    var currentPage: MutableProperty<Int> = MutableProperty(0)
    private var disposableBag = CompositeDisposable()

    init(_ searchRequest: FlickrSearchRequest) {
        self.searchRequest = searchRequest
    }
}

// MARK:- Internal extension
extension FlickrSearchViewModel {
    func fetchPhotos(
        for text: String,
        isInitialLoad: Bool = false
    ) {
        if isInitialLoad {
            photoList.value.removeAll()
            currentPage.value = 0
        }
        fetchPhotos(for: text, page: currentPage.value + 1) { photosResult in
            switch photosResult {
            case let .success(photosResult):
                self.currentPage.value += 1
                self.photoList.value.append(photosResult.photos)
            case let .failure(error):
                print(error)
            }
        }
    }
}

// MARK:- Private extension
private extension FlickrSearchViewModel {
    func fetchPhotos(
        for text: String,
        page: Int = 1,
        photosHandler: @escaping (Result<Flickr.SearchResults, FlickrError>) -> Void
    ) {
        let searchDispose = searchRequest.fetchImages(for: text, page: page)
            .observe(on: QueueScheduler.main)
            .startWithResult { result in
               photosHandler(result)
        }
        disposableBag.add(searchDispose)
    }
}

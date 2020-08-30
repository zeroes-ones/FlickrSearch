//
//  FlickrAPIManager.swift
//  FlickrSearch
//
//  Created by S on 8/30/20.
//  Copyright © 2020 Sandeep. All rights reserved.
//

import Foundation
import ReactiveSwift

struct FlickrAPIManager {
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    private let baseURL: URL? = URL(string: Flickr.API.baseURLpath)
}

extension FlickrAPIManager: FlickrSearchRequest {
    func fetchImages<T: Codable>(for text: String, page: Int) -> SignalProducer<T, FlickrError> {
        guard let baseURL = baseURL else {
            return SignalProducer(error: .urlError)
        }
        let request = SearchRequest(text: text, page: page).request(with: baseURL)
        let session = self.session
        return SignalProducer<T, FlickrError> { (observer, _) in
            session.dataTask(with: request) { (data, response, error) in
                do {
                    guard let data = data else {
                        observer.send(error: .dataCorrupted)
                        return
                    }
                    let model = try JSONDecoder().decode(T.self, from: data)
                    observer.send(value: model)
                } catch let error {
                    print(error)
                    observer.send(error: .decodingError)
                }
                observer.sendCompleted()
            }.resume()
        }
    }
}

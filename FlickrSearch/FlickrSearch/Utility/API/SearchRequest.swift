//
//  SearchRequest.swift
//  FlickrSearch
//
//  Created by S on 8/30/20.
//  Copyright © 2020 Sandeep. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol FlickrSearchRequest {
    func fetchImages(for text: String, page: Int) -> SignalProducer<Flickr.SearchResults, FlickrError>
}

struct SearchRequest: APIRequest {
    var method: HttpMethod = .get
    var path: String = Flickr.API.restPath
    var parameters: [String : String] = [String: String]()
    init(text: String, page: Int) {
        parameters["method"] = Flickr.API.searchMethod
        parameters["api_key"] = Flickr.API.key
        parameters["safe_search"] = "1" //1 for safe. 2 for moderate. 3 for restricted.
        parameters["text"] = text
        parameters["extras"] = "url_s"
        parameters["format"] = "json"
        parameters["nojsoncallback"] = "1"
        parameters["page"] = "\(page)"
    }
}

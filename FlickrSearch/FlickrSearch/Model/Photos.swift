//
//  Photos.swift
//  FlickrSearch
//
//  Created by S on 8/30/20.
//  Copyright © 2020 Sandeep. All rights reserved.
//

import Foundation
enum Flickr { }
extension Flickr {

    struct SearchResults: Codable {
        let photos: Photos
    }

    struct Photos: Codable {
        let page: Int
        let pages: Int
        let perPage: Int
        let total: String
        let photos: [Photo]?
    }

    struct Photo: Codable {
        private let urlString: String?
        let id: String
        let owner: String
        let secret: String
        let server: String
        let farm: Int
        let title: String
        let isPublic: Int
        let isFriend: Int
        let isFamily: Int
        let height: Int
        let width: Int
        var url: URL? {
            guard let urlString = urlString else {
                return nil
            }
            return URL(string: urlString)
        }
    }
}


/// Boiler Plate code for encoding and decoding, we can use `Soucery` framework to generate the models and avoid writing boiler plate code
extension Flickr.Photos {
    private enum CodingKeys: String, CodingKey {
        case page
        case pages
        case perpage
        case total
        case photos = "photo"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        page = try container.decodeIfPresent(Int.self, forKey: .page) ?? -1
        pages = try container.decodeIfPresent(Int.self, forKey: .pages) ?? -1
        perPage = try container.decodeIfPresent(Int.self, forKey: .perpage) ?? -1
        total = try container.decodeIfPresent(String.self, forKey: .total) ?? ""
        photos = try container.decodeIfPresent([Flickr.Photo].self, forKey: .photos)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(page, forKey: .page)
        try container.encode(pages, forKey: .pages)
        try container.encode(perPage, forKey: .perpage)
        try container.encode(total, forKey: .total)
        try container.encodeIfPresent(photos, forKey: .photos)
    }
}

extension Flickr.Photo {
    private enum CodingKeys: String, CodingKey {
        case id
        case owner
        case secret
        case server
        case farm
        case title
        case ispublic
        case isfamily
        case isfriend
        case url_s
        case height_s
        case width_s
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        owner = try container.decodeIfPresent(String.self, forKey: .owner) ?? ""
        secret = try container.decodeIfPresent(String.self, forKey: .secret) ?? ""
        server = try container.decodeIfPresent(String.self, forKey: .server) ?? ""
        farm = try container.decodeIfPresent(Int.self, forKey: .farm) ?? -1
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        isPublic = try container.decodeIfPresent(Int.self, forKey: .ispublic) ?? 0
        isFamily = try container.decodeIfPresent(Int.self, forKey: .isfamily) ?? 0
        isFriend = try container.decodeIfPresent(Int.self, forKey: .isfriend) ?? 0
        urlString = try container.decodeIfPresent(String.self, forKey: .url_s)
        width = try container.decodeIfPresent(Int.self, forKey: .width_s) ?? 0
        height = try container.decodeIfPresent(Int.self, forKey: .height_s) ?? 0
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(owner, forKey: .owner)
        try container.encode(secret, forKey: .secret)
        try container.encode(server, forKey: .server)
        try container.encode(farm, forKey: .farm)
        try container.encode(title, forKey: .title)
        try container.encode(isPublic, forKey: .ispublic)
        try container.encode(isFamily, forKey: .isfamily)
        try container.encode(isFriend, forKey: .isfriend)
        try container.encode(url, forKey: .url_s)
        try container.encode(width, forKey: .width_s)
        try container.encode(height, forKey: .height_s)
    }
}

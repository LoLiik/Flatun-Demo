//
//  Post.swift
//  FlatunDemo
//
//  Created by Евгений on 22.11.2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import Foundation

struct NewsPost: Codable{
    let images: [ImageInfo]
    let title: String
    let published: Date
    let providerAuthorName: String
    let providerAuthorAvatar: URL?
    let likesCount: Int

    init(
        images: [ImageInfo],
        title: String,
        published: Date,
        providerAuthorName: String,
        providerAuthorAvatar: URL?,
        likesCount: Int
        )
    {
        self.images = images
        self.title = title
        self.published = published
        self.providerAuthorName = providerAuthorName
        self.providerAuthorAvatar = providerAuthorAvatar
        self.likesCount = likesCount
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        providerAuthorName = try container.decode(String.self, forKey: .providerAuthorName)
        providerAuthorAvatar = try container.decode(URL?.self, forKey: .providerAuthorAvatar)
        likesCount = try container.decode(Int.self, forKey: .likesCount)

        let dateString = try container.decode(String.self, forKey: .published)
        let formatter = DateFormatter.iso8601Full
        if let date = formatter.date(from: dateString) {
            published = date
        } else {
            print(dateString)
            throw DecodingError.dataCorruptedError(forKey: .published,
                                                   in: container,
                                                   debugDescription: "Date string does not match format expected by formatter.")
        }

        images = try container.decode([ImageInfo].self, forKey: .images)
    }

    private enum CodingKeys: String, CodingKey{
        case images
        case title
        case published
        case providerAuthorName = "provider_author_name"
        case providerAuthorAvatar = "provider_author_avatar"
        case likesCount = "likes_count"
    }
}

//
//  NewsSources.swift
//  FlatunDemo
//
//  Created by Евгений on 22.11.2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import Foundation

struct NewsSource: Codable{
    var id: Int
    var name: String
    var description: String
    var imageURL: URL?

    init(
        id: Int,
        name: String,
        description: String,
        imageURL: URL?
        )
    {
        self.id = id
        self.name = name
        self.description = description
        self.imageURL = imageURL

    }

    //    init(from decoder: Decoder) throws{
    //        let container = try decoder.container(keyedBy: CodingKeys.self)
    //        let id: String = try container.decode(String.self, forKey: .id)
    //        let name: Int = try container.decode(Int.self, forKey: .name)
    //        let twitter: URL = try container.decode(URL.self, forKey: .imageURL)
    //    }

    private enum CodingKeys: String, CodingKey{
        case id
        case name
        case description
        case imageURL = "image"
        //        case rrsURL = "rss_url"
        //        case siteURL = "site_url"
        //        case userActive = "user_active"
        //        case language
        //        //    case tags: [Tag]
        //        case active
        //        case votesCount = "votes_count"
        //        //    case tileType: TileType
        //        case lastFeedItem = "last_feed_item"
    }
}

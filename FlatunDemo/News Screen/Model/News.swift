//
//  PostImage.swift
//  FlatunDemo
//
//  Created by Евгений on 22.11.2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import Foundation

struct News: Codable{
    var nextLink: String?
    var posts = [NewsPost]()

    init(next: String?, posts: [NewsPost]){
        self.nextLink = next
        self.posts = posts
    }

    private enum CodingKeys: String, CodingKey{
        case nextLink = "next"
        case posts = "results"
    }
}

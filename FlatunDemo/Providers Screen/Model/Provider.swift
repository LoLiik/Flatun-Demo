//
//  Providers.swift
//  FlatunDemo
//
//  Created by Евгений on 22.11.2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import Foundation

struct Provider: Codable{
    var id: Int
    var name: String
    var description: String
    var imageURL: URL?

    private enum CodingKeys: String, CodingKey{
        case id
        case name
        case description
        case imageURL = "image"
    }
}

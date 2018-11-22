//
//  News.swift
//  FlatunDemo
//
//  Created by Евгений on 22.11.2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

//import Foundation
import UIKit

struct ImageInfo: Codable{
    let image: URL
    let heigtht: Int
    let width: Int
    let color: UIColor

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        image = try container.decode(URL.self, forKey: .image)
        heigtht = try container.decode(Int.self, forKey: .height)
        width = try container.decode(Int.self, forKey: .width)
        let colorHexString = try container.decode(String.self, forKey: .color)
        color = UIColor(hex: colorHexString)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(image, forKey: .image)
        try container.encode(heigtht, forKey: .height)
        try container.encode(width, forKey: .width)
        let hexColorCode = color.toHexString()
        try container.encode(hexColorCode, forKey: .color)

    }

    private enum CodingKeys: String, CodingKey{
        case image
        case height
        case width
        case color
    }
}

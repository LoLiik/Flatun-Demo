//
//  NewsViewCell.swift
//  FlatunDemo
//
//  Created by Евгений on 21.11.2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit

class NewsPostCVCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImageView: PostImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!

    var newsPost: NewsPost?{ didSet{ updateUI() } }

    private func updateUI(){
        guard let post = newsPost else {
            return
        }
        userNameLabel?.text = post.providerAuthorName.isEmpty ? "Инкогнито" : post.providerAuthorName
        titleLabel?.text = post.title
        likesCountLabel?.text = "\(post.likesCount)"
        let formatter = flatunDateFormatter
        DateLabel?.text = "\(formatter.string(from: post.published))"

        if !post.images.isEmpty{
        mainImageView.loadImageUsingUrlString(urlString: post.images[0].image.absoluteString)
        }
    }
}

private let flatunDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMM yyyy HH:mm:ss"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
}()

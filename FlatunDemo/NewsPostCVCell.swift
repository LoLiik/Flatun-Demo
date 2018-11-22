//
//  NewsViewCell.swift
//  FlatunDemo
//
//  Created by Евгений on 21.11.2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit

class NewsPostCVCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!

    var newsPost: NewsPost?{ didSet{ updateUI() } }

    private func updateUI(){
        guard let post = newsPost else {
            return
        }
        userNameLabel?.text = post.providerAuthorName.isEmpty ? "Инкогнито" : post.providerAuthorName
        titleLabel?.text = post.title
        likesCountLabel?.text = "\(post.likesCount)"

        if !post.images.isEmpty {
            let postImageURL = post.images[0].image
            URLSession.shared.dataTask(with: postImageURL) { (data, response, error) in
                DispatchQueue.main.async {
                    if let imageData = data {
                        self.mainImageView?.image = UIImage(data: imageData)
                    } else {
                        self.mainImageView?.image = nil
                    }
                }
                }.resume()
        }
    }
}


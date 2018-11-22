//
//  NewsSourceTVCell.swift
//  FlatunDemo
//
//  Created by Евгений on 18.11.2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit

class NewsSourceTVCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var logo: UIImageView!

    var newsSource: NewsSource? { didSet { updateUI() } }

    private func updateUI() {
        name?.text = newsSource?.name

        if let logoImageURL = newsSource?.imageURL {
            URLSession.shared.dataTask(with: logoImageURL) { (data, response, error) in
                DispatchQueue.main.async {
                    if let imageData = try? Data(contentsOf: logoImageURL) {
                        self.logo?.image = UIImage(data: imageData)
                    } else {
                        self.logo?.image = nil
                    }
                }
            }.resume()
        }
    }
}


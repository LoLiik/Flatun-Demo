//
//  ProviderTVCell.swift
//  FlatunDemo
//
//  Created by Евгений on 18.11.2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit

class ProviderTVCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var logo: UIImageView!

    var Provider: Provider? { didSet { updateUI() } }

    private func updateUI() {
        name?.text = Provider?.name

        if let logoImageURL = Provider?.imageURL {
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


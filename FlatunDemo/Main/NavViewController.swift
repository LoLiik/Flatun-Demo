//
//  NavViewController.swift
//  FlatunDemo
//
//  Created by Евгений on 23.11.2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit

class NavViewController: UINavigationController {

    var currentSourceId: Int?
    var currentSourceTitle: String?

    @objc func showCollection(_ notification: NSNotification){
        if let id = notification.userInfo?["SourceId"] as? Int{
            currentSourceId = id
            currentSourceTitle = notification.userInfo?["SourceTitle"] as? String
        }
        performSegue(withIdentifier: "ShowNewCollection", sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.showCollection(_:)), name: NSNotification.Name(rawValue: "ShowCollection"), object: nil)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNewCollection"{
            if let destinationVC = segue.destination as? NewsCollectionViewController{
                destinationVC.sourceId = currentSourceId
                destinationVC.title = currentSourceTitle
            }
        }
    }
}

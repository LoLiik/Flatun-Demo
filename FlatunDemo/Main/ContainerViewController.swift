//
//  ContainerViewController.swift
//  FlatunDemo
//
//  Created by Евгений on 23.11.2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    @IBOutlet weak var sideLeadingConstrait: NSLayoutConstraint!
    var sideMenuOpen = false


    @objc func toggleSideMenu(){
        if sideMenuOpen{
            sideLeadingConstrait.constant = 0
        } else {
            sideLeadingConstrait.constant = -250
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: NSNotification.Name(rawValue: "ToggleSideMenu"), object: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

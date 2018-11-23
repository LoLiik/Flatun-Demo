//
//  ContainerViewController.swift
//  FlatunDemo
//
//  Created by Евгений on 23.11.2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    @IBOutlet weak var mainVC: UIView!
    @IBOutlet weak var sideLeadingConstrait: NSLayoutConstraint!
    var sideMenuOpen = true

    @objc func toggleSideMenu(){
        if sideMenuOpen{
            sideLeadingConstrait.constant = 0
        } else {
            sideLeadingConstrait.constant = -265
        }
        sideMenuOpen.toggle()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: NSNotification.Name(rawValue: "ToggleSideMenu"), object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Disapear")
    }

}

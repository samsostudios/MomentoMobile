//
//  ProfileSettingsViewController.swift
//  Momento
//
//  Created by Sam Henry on 3/30/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit

class ProfileSettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let backButton = UIBarButtonItem()
        backButton.title = " "
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.navigationController?.navigationBar.tintColor = Colors.darkBlack
        // Do any additional setup after loading the view.
    }
    

}

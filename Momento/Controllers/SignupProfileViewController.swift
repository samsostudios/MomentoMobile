//
//  SignupProfileViewController.swift
//  Momento
//
//  Created by Sam Henry on 2/23/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit

class SignupProfileViewController: UIViewController {
    
    let bgImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setBG()
        setNavBar()
    }
    
    func setNavBar(){
        //      Navigation Bar Styling
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        }
    
    func setBG (){
        view.addSubview(bgImage)
        bgImage.translatesAutoresizingMaskIntoConstraints = false
        bgImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bgImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bgImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bgImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bgImage.image = UIImage(named: "overlay")
        
        view.sendSubviewToBack(bgImage)
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

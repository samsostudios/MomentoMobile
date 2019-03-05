//
//  ProfileViewController.swift
//  Momento
//
//  Created by Sam Henry on 3/5/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBAction func logoutBtn(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
            print("signed out")
            self.performSegue(withIdentifier: "LogoutProfileSegue", sender: self)
        }catch{
            print("error signing out")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let user = Auth.auth().currentUser!.uid
        print("profile for: ", user)
        // Do any additional setup after loading the view.
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

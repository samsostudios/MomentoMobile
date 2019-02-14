//
//  ProfileViewController.swift
//  Momento
//
//  Created by Sam Henry on 2/13/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBAction func signupBtn(_ sender: UIButton) {
//        let userDb = Database.database().reference()
        
        Auth.auth().createUser(withEmail: emailInput.text!, password: passwordInput.text!) { (user, error) in
            
            if error != nil{
                print(error!)
            }else{
                print("signed up!")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

//
//  LoginProfileViewController.swift
//  Momento
//
//  Created by Sam Henry on 2/23/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit
import Firebase

class LoginProfileViewController: UIViewController {
    
    let bgImage = UIImageView()

    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    var userHandler: AuthStateDidChangeListenerHandle?
    
    @IBAction func signupBtn(_ sender: UIButton) {
//        print("signup pressed")
    }
    
    @IBAction func loginBtn(_ sender: UIButton) {
//        print("login pressed")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBG()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view.
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
    
    override func viewWillAppear(_ animated: Bool) {
        userHandler = Auth.auth().addStateDidChangeListener {
            (auth, user) in
            
            if user != nil {
                print("user!!!!: ", user!.uid)
            }else{
                print("no current user!!!!")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(userHandler!)
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

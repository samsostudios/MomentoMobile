//
//  SignupProfileViewController.swift
//  Momento
//
//  Created by Sam Henry on 2/23/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit
import Firebase

class SignupProfileViewController: UIViewController {
    
    let bgImage = UIImageView()

    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBG()
        setNavBar()
    }
    
    override func viewDidLayoutSubviews() {
        setButton()
    }
    
    
    @IBOutlet weak var signupBtnSetup: UIButton!
    @IBAction func signUp(_ sender: UIButton) {
        print("sign up btn pressed!")
        self.performSegue(withIdentifier: "onboardSegue", sender: self)
//        let userDB = Database.database().reference().child("Users")
        
//        Auth.auth().createUser(withEmail: emailInput.text!, password: passwordInput.text!){
//            (user, error) in
//
//            if error != nil{
//                print("error", error!)
//            }else{
//                print("signed up!")
//
//                let uid = Auth.auth().currentUser!.uid
//                print("UID!!!!: ", uid)
//
//                let userSignupInfo = ["email": self.emailInput.text, "password": self.passwordInput.text]
//
//                userDB.child(uid).setValue(userSignupInfo){
//                    (error, refrence) in
//
//                    if error != nil{
//                        print("error!!! ", error!)
//                    }else{
//                        print("signed up!")
//
//                        self.emailInput.text = ""
//                        self.passwordInput.text = ""
//
//                    }
//                }
//
//                self.performSegue(withIdentifier: "onboardSegue", sender: self)
//
//            }
//        }
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
    
    func setButton(){
        signupBtnSetup.setGradient(colorOne: Colors.lightYellow, colorTwo: Colors.darkYellow)
        signupBtnSetup.clipsToBounds = true
        signupBtnSetup.layer.cornerRadius = 15
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

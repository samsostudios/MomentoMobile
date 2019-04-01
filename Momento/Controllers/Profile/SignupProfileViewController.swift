//
//  SignupProfileViewController.swift
//  Momento
//
//  Created by Sam Henry on 2/23/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit
import Firebase

class SignupProfileViewController: UIViewController, UITextFieldDelegate {
    
    let bgImage = UIImageView()
    
    var userInfo = [String: String]()

    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBG()
        setNavBar()
        
        emailInput.delegate = self
        passwordInput.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        //or
        //self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        setButton()
    }
    
    
    @IBOutlet weak var signupBtnSetup: UIButton!
    @IBAction func signUp(_ sender: UIButton) {
        print("sign up btn pressed!")
        
        print("userInfo: ", self.userInfo)
        
        let email = self.emailInput.text!
        let password = self.passwordInput.text!
        
        if email == "" || password == "" {
            print("ADD ALERT for email and password, user firebase error for password")
        }else{
            self.userInfo = ["Email": email, "Password": password]
//            print("userInfo: ", self.userInfo)
            self.performSegue(withIdentifier: "onboardSegue", sender: self)
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let onBoard1VC = segue.destination as! Onboard1ViewController
        onBoard1VC.userInfo = self.userInfo
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

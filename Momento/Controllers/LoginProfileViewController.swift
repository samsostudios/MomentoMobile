//
//  LoginProfileViewController.swift
//  Momento
//
//  Created by Sam Henry on 2/23/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit
import Firebase

class LoginProfileViewController: UIViewController, UITextFieldDelegate {
    
    let bgImage = UIImageView()

    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    var userHandler: AuthStateDidChangeListenerHandle?
    
    @IBAction func signupBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "SignUpSegue", sender: self)
    }
    
    @IBOutlet weak var loginBtnSetup: UIButton!
    @IBAction func loginBtn(_ sender: UIButton) {
        let email = emailInput.text!
        let password = passwordInput.text!
        
        if email != "" && password != ""{
            Auth.auth().signIn(withEmail: email, password: password){
                (error, refrence) in
                
                if error != nil{
                    print("Login Error!!!!: ", error!)
                }else{
                    print("login Succesful!!!")
                    self.performSegue(withIdentifier: "ProfileSegueLogin", sender: self)
                }
            }
        }else{
            print("error logging in!")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBG()
        emailInput.delegate = self
        passwordInput.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view.
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
        loginBtnSetup.setGradient(colorOne: Colors.lightYellow, colorTwo: Colors.darkYellow)
        loginBtnSetup.clipsToBounds = true
        loginBtnSetup.layer.cornerRadius = 15
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userHandler = Auth.auth().addStateDidChangeListener {
            (auth, user) in
            
            if user != nil {
                print("user!!!!: ", user!.uid)
                self.performSegue(withIdentifier: "ProfileSegueLogin", sender: self)
                
                
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

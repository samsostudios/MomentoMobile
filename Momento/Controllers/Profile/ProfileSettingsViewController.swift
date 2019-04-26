//
//  ProfileSettingsViewController.swift
//  Momento
//
//  Created by Sam Henry on 3/30/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit
import Firebase

class ProfileSettingsViewController: UIViewController {
    
    @IBOutlet weak var headerPhoto: UIImageView!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let backButton = UIBarButtonItem()
        backButton.title = " "
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.navigationController?.navigationBar.tintColor = Colors.darkBlack
        
        let headerPhotoHeight = headerPhoto.frame.height
        headerPhoto.layer.cornerRadius = headerPhotoHeight/2
        
        nameTextField.backgroundColor = .clear
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.borderColor = Colors.darkBlack.cgColor
        nameTextField.layer.cornerRadius = 5.0
        
        usernameTextField.backgroundColor = .clear
        usernameTextField.layer.borderWidth = 1.0
        usernameTextField.layer.borderColor = Colors.darkBlack.cgColor
        usernameTextField.layer.cornerRadius = 5.0
        
        bioTextField.backgroundColor = .clear
        bioTextField.layer.borderWidth = 1.0
        bioTextField.layer.borderColor = Colors.darkBlack.cgColor
        bioTextField.layer.cornerRadius = 5.0
        
        let currentUserId = Auth.auth().currentUser?.uid
        if currentUserId != nil {
            let headerDBRef = Database.database().reference().child("Header Photos").child(currentUserId!)
            headerDBRef.observeSingleEvent(of: .value) {
                (snapshot, error) in
                
                if error != nil {
                    print("ERROR", error)
                }else{
                    if snapshot.exists() {
                        
                    }else {
                        self.headerPhoto.image = UIImage(named: "stockUserPhoto")
                    }
                }
            }
            
            let userDBRef = Database.database().reference().child("Users").child(currentUserId!)
            userDBRef.observeSingleEvent(of: .value){
                (snapshot, error) in
                
                if error != nil{
                    print("ERROR with user snap", error)
                }else{
                    print("SNAP", snapshot)
                    let snapObejct = snapshot.value as! NSDictionary
                    
                    let name = snapObejct["Name"] as! String
                    let username = snapObejct["Username"] as! String
                    
                    self.nameTextField.text = name
                    self.usernameTextField.text = username
                }
            }
        }
        
    }
    

}

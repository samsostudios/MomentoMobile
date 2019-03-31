//
//  Onboard2ViewController.swift
//  Momento
//
//  Created by Sam Henry on 3/4/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit
import Firebase

class Onboard2ViewController: UIViewController {
    
    var userInfo = [String: String]()
    
    var buttonsSelected = [1: false, 2: false, 3: false,
                           4: false, 5: false, 6: false,
                           7: false, 8: false]
    
    let bgImage = UIImageView()
    
    @IBAction func graphicDesignBtn(_ sender: Any) {
        buttonsSelected[1] = true
    }
    @IBAction func uxBtn(_ sender: UIButton) {
        buttonsSelected[2] = true
    }
    @IBAction func webBtn(_ sender: UIButton) {
        buttonsSelected[3] = true
    }
    @IBAction func appBtn(_ sender: UIButton) {
        buttonsSelected[4] = true
    }
    @IBAction func photoBtn(_ sender: UIButton) {
        buttonsSelected[5] = true
    }
    @IBAction func videoBtn(_ sender: UIButton) {
        buttonsSelected[6] = true
    }
    @IBAction func illustrationBtn(_ sender: UIButton) {
        buttonsSelected[7] = true
    }
    @IBAction func animationBtn(_ sender: UIButton) {
        buttonsSelected[8] = true
    }
    
    
    
    
    @IBOutlet weak var signupBtnSetup: UIButton!
    @IBAction func signupBtn(_ sender: UIButton) {
        var designTypes: [String] = []
//        print("buttons selected:", self.buttonsSelected)
        
        for (key, value) in buttonsSelected{
            
            switch key {
            case 1:
                if value == true{
                    designTypes.append("Graphic Design")
                    self.userInfo["Graphic Design"] = ""
                }
            case 2:
                if value == true{
                    designTypes.append("UX Design")
                    self.userInfo["UX Design"] = ""
                }
            case 3:
                if value == true{
                    designTypes.append("Web Design")
                    self.userInfo["Web Design"] = ""
                }
            case 4:
                if value == true{
                    designTypes.append("App Design")
                    self.userInfo["App Design"] = ""
                }
            case 5:
                if value == true{
                    designTypes.append("Photography")
                    self.userInfo["Photography"] = ""
                }
            case 6:
                if value == true{
                    designTypes.append("Videography")
                    self.userInfo["Videography"] = ""
                }
            case 7:
                if value == true{
                    designTypes.append("Illustration")
                    self.userInfo["Illustration"] = ""
                }
            case 8:
                if value == true{
                    designTypes.append("Animation")
                    self.userInfo["Animation"] = ""
                }
            default:
                print("error")
            }
        }
        
        
        if designTypes.count == 0{
            print("Please select a design type")
            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            
            alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = Colors.darkBlack
            
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white] as [NSAttributedString.Key: Any]
            let titleAttrString = NSMutableAttributedString(string: "Please select a type of design", attributes: attributes)
            
            alert.setValue(titleAttrString, forKey: "attributedTitle")
            alert.view.tintColor = Colors.darkYellow
            
            present(alert, animated: true, completion: nil)
        }
        else{
            
            var signupInfo = [String: String]()
            var types  = [String: Bool]()
            var otherInfo = [String: String]()
            
            for (key, value) in self.userInfo{
//                print("items:", key, value)
                
                if key == "Email" || key == "Password" {
                    signupInfo[key] = value
                }
                if value == ""{
                    types[key] = true
                }
                else{
                    otherInfo[key] = value
                }
            }
            
            signIn(signupInfo: signupInfo, types: types, otherInfo: otherInfo)
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(buttonsSelected[1]!)
        
        setBG()
//        print("OB@ user info: ", self.userInfo)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        setButton()
    }
    
    func setBG() {
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
    
    func signIn(signupInfo: [String: String], types: [String: Bool], otherInfo: [String: String]){
        print("SUinfo", signupInfo)
        print("types", types)
        print("other", otherInfo)
        
        let userDB = Database.database().reference().child("Users")
        let designTypesDB = Database.database().reference().child("Design Types")
        let usernamesDB = Database.database().reference().child("Usernames")
        
        Auth.auth().createUser(withEmail: signupInfo["Email"]!, password: signupInfo["Password"]!){
            (user, error) in
            
            if error != nil {
                print("ADD ALERR info not good")
            }else{
                print("sign up good!")
                let uid = Auth.auth().currentUser!.uid
                
                userDB.child(uid).setValue(signupInfo)
                userDB.child(uid).setValue(otherInfo)
                
                for (key, value) in types{
                    print("types", key, value)
                    userDB.child(uid).child("Design Types").child(key).setValue(true)
                    designTypesDB.child(key).child("Members").child(uid).setValue(true)
                }
                for (key, value) in otherInfo{
                    if key == "Username"{
                        usernamesDB.child(uid).setValue(value)
                    }
                }
                self.performSegue(withIdentifier: "ProfileSegueOnboard", sender: self)
            }
        }
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

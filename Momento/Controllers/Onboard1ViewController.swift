//
//  Onboard1ViewController.swift
//  Momento
//
//  Created by Sam Henry on 2/26/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit
import Firebase

class Onboard1ViewController: UIViewController {
    
    let bgImage = UIImageView()

    @IBOutlet weak var nameInput: UITextField!
    @IBAction func usernameInput(_ sender: UITextField) {
        let username = sender.text!
        
        let usernameDB = Database.database().reference().child("Usernames")
        
        usernameDB.observeSingleEvent(of: .value, with: { (DataSnapshot) in
            
        })
        
    }
    @IBOutlet weak var phoneInput: UITextField!
    
    @IBOutlet weak var dobPicker: UIDatePicker!
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBAction func continueBtnSegue(_ sender: UIButton) {
        let userDB = Database.database().reference().child("Users")
        let uid = Auth.auth().currentUser!.uid
        
        let fullName = nameInput.text!
        let phoneNumber = phoneInput.text!
        
        dobPicker.datePickerMode = .date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let selectedDate = dateFormatter.string(from: dobPicker.date)
        
        if fullName == ""{
            print("Please Add Name!")
        }else{
            userDB.child(uid).child("Name").setValue(fullName){
                (error, refrence) in
                
                if error != nil{
                    print("Error!", error!)
                }else{
                    print("Success!")
                }
            }
        }
        if phoneNumber == ""{
           print("Please Add Phone Number!")
        }else{
            userDB.child(uid).child("Phone Number").setValue(phoneNumber){
                (error, refrence) in
                
                if error != nil{
                    print("Error!", error!)
                }else{
                    print("Success!")
                }
            }
        }
        if selectedDate == ""{
            print("Please Add Date of Birth!")
        }else{
            userDB.child(uid).child("Birth Date").setValue(selectedDate){
                (error, refrence) in
                
                if error != nil{
                    print("Error!", error!)
                }else{
                    print("Success!")
                }
            }
        }
        
        performSegue(withIdentifier: "onboard2Segue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dobPicker.setValue(UIColor.white, forKey: "textColor")
        
        setBG()
        setInput()
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
    
    func setInput() {
        nameInput.layer.cornerRadius = 5;
        nameInput.layer.borderColor = #colorLiteral(red: 0.9901060462, green: 0.6932173967, blue: 0.1471862197, alpha: 1)
        nameInput.layer.borderWidth = 1
        
        phoneInput.layer.cornerRadius = 5;
        phoneInput.layer.borderColor = #colorLiteral(red: 0.9901060462, green: 0.6932173967, blue: 0.1471862197, alpha: 1)
        phoneInput.layer.borderWidth = 1
    }
    
    func setButton(){
        continueBtn.setGradient(colorOne: Colors.lightYellow, colorTwo: Colors.darkYellow)
        continueBtn.clipsToBounds = true
        continueBtn.layer.cornerRadius = 15
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

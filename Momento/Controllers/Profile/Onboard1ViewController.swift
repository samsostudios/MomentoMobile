//
//  Onboard1ViewController.swift
//  Momento
//
//  Created by Sam Henry on 2/26/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit
import Firebase

class Onboard1ViewController: UIViewController, UITextFieldDelegate {
    
    let bgImage = UIImageView()
    
    var userInfo = [String: String]()

    @IBOutlet weak var nameInput: UITextField!
    
    @IBOutlet weak var usernameInput: UITextField!
    @IBAction func usernameCheck(_ sender: UITextField) {
        let username = usernameInput.text!
        print("username:", username)
        

        let usernamesDB = Database.database().reference().child("Usernames")
        
        usernamesDB.observeSingleEvent(of: .value) {snapshot in
            print("snapshot!", snapshot.childrenCount)
            
            var nameTaken = false
            
            for item in snapshot.children.allObjects as! [DataSnapshot]{
//                print("database items: ", item.value!)
                
                let usernameItemCheck = item.value as! String
                
                if usernameItemCheck == username{
                    nameTaken = true
                }
            }
            
            
            if nameTaken == true{
                print("ADD ALERT for username taken")
            }else{
                self.userInfo["Username"] = username
                
            }
        }
    }
    
    @IBOutlet weak var phoneInput: UITextField!
    
    @IBOutlet weak var dobPicker: UIDatePicker!
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBAction func continueBtnSegue(_ sender: UIButton) {
        
        let fullName = nameInput.text!
        let phoneNumber = phoneInput.text!
        
        dobPicker.datePickerMode = .date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let selectedDate = dateFormatter.string(from: dobPicker.date)
        
        if fullName == ""{
            print("Please Add Name!")
        }else{
            self.userInfo["Name"] = fullName
        }
        if phoneNumber == ""{
           print("Please Add Phone Number!")
        }else{
            self.userInfo["Phone Number"] = phoneNumber
        }
        if selectedDate == ""{
            print("Please Add Date of Birth!")
        }else{
            self.userInfo["Birth Date"] = selectedDate
        }
        
        performSegue(withIdentifier: "onboard2Segue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dobPicker.setValue(UIColor.white, forKey: "textColor")
        
        setBG()
        setInput()
        
        nameInput.delegate = self
        usernameInput.delegate = self
        phoneInput.delegate = self
        
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
        
        usernameInput.layer.cornerRadius = 5;
        usernameInput.layer.borderColor = #colorLiteral(red: 0.9901060462, green: 0.6932173967, blue: 0.1471862197, alpha: 1)
        usernameInput.layer.borderWidth = 1
        
        phoneInput.layer.cornerRadius = 5;
        phoneInput.layer.borderColor = #colorLiteral(red: 0.9901060462, green: 0.6932173967, blue: 0.1471862197, alpha: 1)
        phoneInput.layer.borderWidth = 1
    }
    
    func setButton(){
        continueBtn.setGradient(colorOne: Colors.lightYellow, colorTwo: Colors.darkYellow)
        continueBtn.clipsToBounds = true
        continueBtn.layer.cornerRadius = 15
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let onBoard2VC = segue.destination as! Onboard2ViewController
        onBoard2VC.userInfo = self.userInfo
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

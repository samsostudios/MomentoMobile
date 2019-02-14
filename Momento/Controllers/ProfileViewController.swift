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

    @IBOutlet weak var textEnter: UITextField!
    @IBAction func submitBtn(_ sender: UIButton) {
        
        let dataDB = Database.database().reference().child("Data")
        let input = textEnter.text!
        
        dataDB.childByAutoId().setValue(input) {
            (error, refrence) in
            
            if error != nil {
                print(error!)
            }else{
                print("data sent")
                self.textEnter.text = ""
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

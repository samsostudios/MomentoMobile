//
//  Onboard1ViewController.swift
//  Momento
//
//  Created by Sam Henry on 2/26/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit

class Onboard1ViewController: UIViewController {
    
    let bgImage = UIImageView()

    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var lastNameInput: UITextField!
    @IBOutlet weak var phoneInput: UITextField!
    
    @IBOutlet weak var dobPicker: UIDatePicker!
    
    @IBOutlet weak var continueBtn: UIButton!
    @IBAction func continueBtnSegue(_ sender: UIButton) {
        print("continue pressed")
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
        
        lastNameInput.layer.cornerRadius = 5;
        lastNameInput.layer.borderColor = #colorLiteral(red: 0.9901060462, green: 0.6932173967, blue: 0.1471862197, alpha: 1)
        lastNameInput.layer.borderWidth = 1
        
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

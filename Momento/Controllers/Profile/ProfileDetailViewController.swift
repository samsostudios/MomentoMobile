//
//  ProfileDetailViewController.swift
//  Momento
//
//  Created by Sam Henry on 3/30/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit

class ProfileDetailViewController: UIViewController {

    var selectedImage: UIImage = UIImage()
    var postID: String = ""
    var username = ""
    var types = [String]()

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
        print("SELECTED", selectedImage)
        detailImageView.image = selectedImage
        
        self.view.backgroundColor = Colors.darkBlack
        
        print("USERNAME", username)
        usernameLabel.text = username
        
        var displayTypes: String = ""
        
        for item in types {
            print("item", item)
            displayTypes = displayTypes + item + ", "
            
            print("Display types", displayTypes)
            
            typesLabel.text = displayTypes
        }
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

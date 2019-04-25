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
    var caption = ""

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.darkBlack
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.tintColor = Colors.darkYellow
        
        print("SELECTED", selectedImage)
        detailImageView.image = selectedImage
        
        print("USERNAME", username)
        usernameLabel.text = username
        
        var displayTypes: String = ""
        
        typesLabel.text = caption
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

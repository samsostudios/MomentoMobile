//
//  SearchDetailPhotoViewController.swift
//  Momento
//
//  Created by Sam Henry on 4/1/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit

class SearchDetailPhotoViewController: UIViewController {
    
    var selectedImage  = UIImage()
    var username: String = ""
    var caption = ""

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.darkBlack
        
        print("INCOMING DATA", selectedImage, ",", username)
        
        let backButton = UIBarButtonItem()
        backButton.title = " "
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        imageView.image = selectedImage
        usernameLabel.text = caption

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

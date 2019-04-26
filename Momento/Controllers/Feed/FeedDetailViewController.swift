//
//  FeedDetailViewController.swift
//  Momento
//
//  Created by Sam Henry on 4/2/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit

class FeedDetailViewController: UIViewController {
    
    var incomingImage = UIImage()
    var incomingCaption = ""
    var incomingUID = ""

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.darkBlack
        
        print("uid", incomingUID, "caption", incomingCaption)
        captionLabel.text = incomingCaption
        
        let backButton = UIBarButtonItem()
        backButton.title = " "
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear

        print("INCOMING", incomingImage)
        imageView.image = incomingImage
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

//
//  SearchDetailPhotoViewController.swift
//  Momento
//
//  Created by Sam Henry on 4/1/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit
import Firebase

class SearchDetailPhotoViewController: UIViewController {
    
    var selectedImage  = UIImage()
    var username: String = ""
    var caption = ""
    var selectedUserId = ""
    
    var selectedImagePostID = ""
    
    var likeSelected = Bool()

    @IBOutlet weak var imageOverlay: UIImageView!
    @IBOutlet weak var likeButtonSetup: UIButton!
    @IBAction func likeButton(_ sender: UIButton) {
        print("IS LIKED", likeSelected)
//        print("POST KEY", selectedImagePostID)
        let currentUserID = Auth.auth().currentUser?.uid
        let contentLikesDBRef = Database.database().reference().child("Content").child(selectedUserId).child("Posts").child(selectedImagePostID).child("Likes").child(currentUserID!)
        
        if likeSelected == true {
            print("DELETE FROM DB")
            self.likeSelected = false
            let unlikedButton = UIImage(named: "heartOutline")
            self.likeButtonSetup.setImage(unlikedButton, for: .normal)
            self.likeButtonSetup.tintColor = Colors.darkYellow
            self.likeButtonSetup.contentMode = .scaleAspectFit
        
            contentLikesDBRef.removeValue(completionBlock: {
                (error, snapshot) in
                
                if error != nil {
                    print("ERROR!!!", error!)
                }else{
                    print("Delete Successful")
                }
            })
            
        }else{
            print("ADD TO DB")
            contentLikesDBRef.setValue(true)

        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.darkBlack
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageOverlay.addSubview(blurEffectView)
        
        imageOverlay.backgroundColor = Colors.darkBlack.withAlphaComponent(0.1)
        imageOverlay.layer.cornerRadius = 10.0
        imageOverlay.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
//        print("INCOMING DATA", selectedImage, ",", username)
        
        let backButton = UIBarButtonItem()
        backButton.title = " "
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        let unlikedButton = UIImage(named: "heartOutline")
        self.likeButtonSetup.setImage(unlikedButton, for: .normal)
        self.likeButtonSetup.tintColor = Colors.darkYellow
        self.likeButtonSetup.contentMode = .scaleAspectFit
        
        imageView.image = selectedImage
        usernameLabel.text = caption
        
        let currentUserID = Auth.auth().currentUser?.uid
        let contentLikesDBRef = Database.database().reference().child("Content").child(selectedUserId).child("Posts")
        
        contentLikesDBRef.observe(.childAdded, with: {
            snapshot in
            
//            print("SNAP", snapshot.key)
            let snapObject = snapshot.value as! NSDictionary
//            print(snapObject)
            print("SNAP OBJ", snapObject["Caption"]!)
            
            if snapObject["Caption"] as! String == self.caption {
                print("FOUND MATCH")
                let postKey = snapshot.key
                print("POST KEY", postKey)
                
                self.selectedImagePostID = postKey
                
                let likesDBRef = Database.database().reference().child("Content").child(self.selectedUserId).child("Posts").child(postKey).child("Likes")
                likesDBRef.observe(.childAdded) {
                    snapshot in
                    
                    print("SNAP!!", snapshot.key)
                    let likesUidKey = snapshot.key
                    
                    if likesUidKey == currentUserID {
                        print("USER DOES LIKE")
                        let likedButton = UIImage(named: "heartSolid")
                        self.likeButtonSetup.setImage(likedButton, for: .normal)
                        self.likeButtonSetup.tintColor = Colors.darkYellow
                        self.likeButtonSetup.contentMode = .scaleAspectFit
                        self.likeSelected = true
                    }
//                    let likesObject = snapshot as! NSDictionary
//                    print("likes obj", likesObject)
//
//                    for item in likesObject {
//                        print("ITEM!", item.key)
//                    }
                }
            }
        })

    }
}

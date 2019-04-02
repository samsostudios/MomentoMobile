//
//  SearchDetailViewController.swift
//  Momento
//
//  Created by Sam Henry on 4/1/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit
import Firebase

class SearchDetailViewController: UIViewController {
    
    var incomingUserInfo  = [String: Any]()
    
    var userImage = UIImage()
    var userName = ""
    var userID = ""
    
    let testImage1 = #imageLiteral(resourceName: "7R8A0139")
    let testImage2 = #imageLiteral(resourceName: "7R8A9956 2")
    let testImage3 = #imageLiteral(resourceName: "7R8A9987Crop")
    
    var testImages: [UIImage] = []
    
    @IBOutlet weak var headerPhoto: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var designTypesLabel: UILabel!
    
    @IBAction func followButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        print("selected", sender.isSelected)
        
        let currentUserId = Auth.auth().currentUser?.uid
        let selectedUserfollowingDBRef = Database.database().reference().child("Followings").child(userID).child("Followers")
        let currentUserDBRef = Database.database().reference().child("Followings").child(currentUserId!).child("Following")
        
        if sender.isSelected == true {
            //add follower for selected user
            selectedUserfollowingDBRef.child(currentUserId!).setValue("true")
            
            //add following for current user
            currentUserDBRef.child(userID).setValue("true")
        }else{
            //delete follower for selected user
            selectedUserfollowingDBRef.child(currentUserId!).removeValue(completionBlock: {
                (error, snapshot) in
                
                if error != nil {
                    print("ERROR!!!", error!)
                }else{
                    print("Delete Successful")
                }
            })
            
            //delete following for current user
            currentUserDBRef.child(userID).removeValue(completionBlock: {
                (error, snapshot) in
                
                if error != nil {
                    print("ERROR", error!)
                }else{
                    print("Delete Succesfull")
                }
            })
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.darkBlack
        
        testImages.append(testImage1)
        testImages.append(testImage2)
        testImages.append(testImage3)
        
        userImage = incomingUserInfo["image"] as! UIImage
        headerPhoto.image = userImage
        
        userName = incomingUserInfo["username"] as! String
        usernameLabel.text = userName
        
        userID = incomingUserInfo["uid"] as! String
        
        var userTypesLabel: String = ""
        
        let designTypesDBRef = Database.database().reference().child("Design Types")
        designTypesDBRef.observe(.childAdded, with: {
            snapshot in
            
//            print("snapshot", snapshot.key)
            let designTypesObject = snapshot.value as! NSDictionary
            for item in designTypesObject {
//                print("item", type(of: item.value))
                
                let itemValues = item.value as! NSDictionary
                for uid in itemValues {
//                    print("UID", uid)
                    if uid.key as! String == self.userID {
                        
                        let appendText = snapshot.key
                        userTypesLabel = userTypesLabel + appendText + ", "
                    }else{
                        print("error getting types")
                    }
                }
            }
            
            print("user label", userTypesLabel)
            self.designTypesLabel.text = userTypesLabel
            
        })
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

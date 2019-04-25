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
    var userImages = [UIImage]()

    
    var userImage = UIImage()
    var userName = ""
    var userID = ""
    var userPosts = [userPost]()
    
    var userTypesLabel: String = ""
    
    var followButtonSelected = Bool()
    
    let testImage1 = #imageLiteral(resourceName: "7R8A0139")
    let testImage2 = #imageLiteral(resourceName: "7R8A9956 2")
    let testImage3 = #imageLiteral(resourceName: "7R8A9987Crop")
    
    var testImages: [UIImage] = []

    @IBOutlet weak var headerPhoto: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var designTypesLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var followButtonSetup: UIButton!
    
    @IBAction func followButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
//        print("selected", sender.isSelected)
        
        let currentUserId = Auth.auth().currentUser?.uid
        let selectedUserfollowingDBRef = Database.database().reference().child("Followings").child(userID).child("Followers")
        let currentUserDBRef = Database.database().reference().child("Followings").child(currentUserId!).child("Following")
        
        if sender.isSelected == true {
            followButtonSetup.setBackgroundImage(#imageLiteral(resourceName: "followButon") , for: UIControl.State.normal)
            followButtonSelected = true
            //add follower for selected user
            selectedUserfollowingDBRef.child(currentUserId!).setValue("true")
            
            //add following for current user
            currentUserDBRef.child(userID).setValue("true")
        }else{
            followButtonSetup.setBackgroundImage(#imageLiteral(resourceName: "followButtonUN"), for: UIControl.State.normal)
            followButtonSelected = false
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
        self.collectionView.backgroundColor = UIColor(white: 1, alpha: 0)
        
        print("INCOMING DATA", self.incomingUserInfo)
        
        testImages.append(testImage1)
        testImages.append(testImage2)
        testImages.append(testImage3)
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        userImage = incomingUserInfo["image"] as! UIImage
        headerPhoto.image = userImage
        
        userName = incomingUserInfo["username"] as! String
        usernameLabel.text = userName
        
        userID = incomingUserInfo["uid"] as! String
        
        print("follow button selected", followButtonSelected)
        
        let currentUserId = Auth.auth().currentUser?.uid
        let followingDBRef = Database.database().reference().child("Followings").child(userID).child("Followers")
        let designTypesDBRef = Database.database().reference().child("Design Types")
        let contentDBRef = Database.database().reference().child("Content").child(userID).child("Posts")
        
//        print("Current user", currentUserId)
        
        var userFollowing = [String]()
        
        followingDBRef.observeSingleEvent(of: .value, with: {
            snapshot in
            
            print("SNAP", snapshot)
            
            if snapshot.key == currentUserId {
                userFollowing.append(snapshot.key)
            }
            DispatchQueue.main.async {
                print("users following", userFollowing)
                if userFollowing.contains(currentUserId!) {
                    print("Following")
                    self.followButtonSetup.setBackgroundImage(#imageLiteral(resourceName: "followButon"), for: UIControl.State.normal)
                }else{
                    print("not following")
                    self.followButtonSetup.setBackgroundImage(#imageLiteral(resourceName: "followButtonUN"), for: UIControl.State.normal)
                }
            }
        })
        
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
                        self.userTypesLabel = self.userTypesLabel + appendText + ", "
                    }else{
//                        print("error getting types")
                    }
                }
            }
            
//            print("user label", userTypesLabel)
            self.designTypesLabel.text = self.userTypesLabel
            
        })
        
        contentDBRef.observe(.childAdded, with: {
            snapshot in
            
            print("Content snap", snapshot.value!)
            
            var linkArray = [String]()
            
            let snapObject = snapshot.value as! NSDictionary
            let caption = snapObject["Caption"] as! String
            
            let imageObject = snapObject["Images"] as! NSArray
            
            for image in imageObject {
                print("IMAGE", image)
                let imageLink = image as! String
                linkArray.append(imageLink)
            }
            
            self.dowloadImages(caption: caption, dlLinks: linkArray)
            
        })
    }
    
    func dowloadImages(caption: String, dlLinks: [String]) {
        print("IN DOWLOAD")
//        print("CAPTION", caption)
        
        let profileImageLink = dlLinks.first as! String
        var imageHolder = userPost(caption: "", image: UIImage())
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.global(qos: .background).async {
            print("DOWNLOADING")
            let storageRef = Storage.storage().reference(forURL: profileImageLink)
            storageRef.downloadURL {
                (url, error) in
                
                if let data = try? Data(contentsOf: url!){
                    if let image = UIImage(data: data){
                        imageHolder = userPost(caption: caption, image: image)
                        self.userPosts.append(imageHolder)
                    }
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            print("DOWNLOAD COMPLETE")
            print("USER POSTS", self.userPosts)
            self.collectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeachShowPhoto" {
            let imageSelected = collectionView?.indexPath(for: sender as! SearchDetailCollectionViewCell)
            print("SELECTED IMAGE", imageSelected!.row)
            let imageDetail = segue.destination as! SearchDetailPhotoViewController
            
            imageDetail.selectedImage = self.userPosts[imageSelected!.row].image
            imageDetail.username = userName
            imageDetail.caption = self.userPosts[imageSelected!.row].caption
        }
        
    }
}

// MARK :: Custom Collection view setup
extension SearchDetailViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {

        let image = self.userPosts[indexPath.row].image
        let height = (image.size.height)/10

        return height
    }
}
extension SearchDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count", self.userPosts.count)
        return self.userPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SerachDetailCell", for: indexPath) as! SearchDetailCollectionViewCell
        
        print("userImages", self.userImages)
        let image = self.userPosts[indexPath.row].image
        cell.cellImage.image = image
        return cell
    }
}

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
    
    var isFollowing = Bool()
    
    @IBOutlet weak var headerPhoto: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var designTypesLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var followButtonSetup: UIButton!
    @IBOutlet weak var headerPhotoOverlay: UIImageView!
    
    @IBAction func followButton(_ sender: UIButton) {
        print("is following?", isFollowing)
        
        let currentUserId = Auth.auth().currentUser?.uid
        let selectedUserfollowingDBRef = Database.database().reference().child("Followings").child(userID).child("Followers")
        let currentUserDBRef = Database.database().reference().child("Followings").child(currentUserId!).child("Following")

        
        if isFollowing == true {
            print("unfollow")
            isFollowing = false
            followButtonSetup.backgroundColor = .clear
            followButtonSetup.setTitleColor(Colors.darkYellow, for: .normal)
            
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
        }else{
            print("follow")
            isFollowing = true
            followButtonSetup.backgroundColor = Colors.darkYellow
            followButtonSetup.setTitleColor(Colors.white, for: .normal)
            
            //add follower for selected user
            selectedUserfollowingDBRef.child(currentUserId!).setValue("true")
            
            //add following for current user
            currentUserDBRef.child(userID).setValue("true")
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.darkBlack
        self.collectionView.backgroundColor = UIColor(white: 1, alpha: 0)
        
        print("DATA PASSED", incomingUserInfo)
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerPhotoOverlay.addSubview(blurEffectView)
        
        headerPhotoOverlay.backgroundColor = Colors.darkBlack.withAlphaComponent(0.1)
        headerPhotoOverlay.layer.cornerRadius = 10.0
        headerPhotoOverlay.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        let buttonHeight = followButtonSetup.bounds.height
        followButtonSetup.backgroundColor = .clear
        followButtonSetup.layer.cornerRadius = buttonHeight/2
        followButtonSetup.layer.borderWidth = 1.0
        followButtonSetup.layer.borderColor = Colors.darkYellow.cgColor
        userImage = incomingUserInfo["image"] as! UIImage
        headerPhoto.image = userImage
        
        userName = incomingUserInfo["username"] as! String
        usernameLabel.text = userName
        
        userID = incomingUserInfo["uid"] as! String
        
        let currentUserId = Auth.auth().currentUser?.uid
        let followingDBRef = Database.database().reference().child("Followings").child(userID).child("Followers")
        let designTypesDBRef = Database.database().reference().child("Design Types")
        let contentDBRef = Database.database().reference().child("Content").child(userID).child("Posts")
        
//        print("Current user", currentUserId)
        
        var userFollowing = [String]()
        
        followingDBRef.observeSingleEvent(of: .value, with: {
            snapshot in
            
//            print("FOLLOWING SNAP", snapshot)
            if snapshot.exists() == false{
                print("USER HAS NO FOLLOWERS")
            }else{
                let followersObject = snapshot.value as! NSDictionary
//                print("FOLLOWER OBJECT", followersObject)
                
                for (key, _) in followersObject {
//                    print("KEY", key)
                    let currentSnapUser = key as! String
                    if currentSnapUser == currentUserId {
                        self.isFollowing = true
                        self.setFollowButton()
                    }
                }
            }
 
            
//            if snapshot.key == currentUserId {
//                userFollowing.append(snapshot.key)
//            }
//            DispatchQueue.main.async {
//                print("users following", userFollowing)
//                if userFollowing.contains(currentUserId!) {
//                    print("Following")
//                    self.followButtonSelected = true
//                    self.setFollowButton()
//
//                }else{
//                    print("not following")
//                    self.followButtonSetup.setBackgroundImage(#imageLiteral(resourceName: "followButtonUN"), for: UIControl.State.normal)
//                }
//            }
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
            
//            print("Content snap", snapshot.value!)
            
            var linkArray = [String]()
            
            let snapObject = snapshot.value as! NSDictionary
            let caption = snapObject["Caption"] as! String
            
            let imageObject = snapObject["Images"] as! NSArray
            
            for image in imageObject {
//                print("IMAGE", image)
                let imageLink = image as! String
                linkArray.append(imageLink)
            }
            
            self.dowloadImages(caption: caption, dlLinks: linkArray)
            
        })
    }
    
    func dowloadImages(caption: String, dlLinks: [String]) {
        
        let profileImageLink = dlLinks.first as! String
        var imageHolder = userPost(caption: "", image: UIImage())
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.global(qos: .background).async {
//            print("DOWNLOADING")
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
//            print("DOWNLOAD COMPLETE")
//            print("USER POSTS", self.userPosts)
            self.collectionView.reloadData()
        }
    }
    
    func setFollowButton() {
        print("Setting follow button", isFollowing)
        followButtonSetup.text("Following")
        followButtonSetup.setTitleColor(Colors.white, for: .normal)
        followButtonSetup.backgroundColor = Colors.darkYellow
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeachShowPhoto" {
            let imageSelected = collectionView?.indexPath(for: sender as! SearchDetailCollectionViewCell)
//            print("SELECTED IMAGE", imageSelected!.row)
            let imageDetail = segue.destination as! SearchDetailPhotoViewController
            
            imageDetail.selectedImage = self.userPosts[imageSelected!.row].image
            imageDetail.username = userName
            imageDetail.caption = self.userPosts[imageSelected!.row].caption
            imageDetail.selectedUserId = incomingUserInfo["uid"] as! String
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
//        print("count", self.userPosts.count)
        return self.userPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SerachDetailCell", for: indexPath) as! SearchDetailCollectionViewCell
        
//        print("userImages", self.userImages)
        let image = self.userPosts[indexPath.row].image
        cell.cellImage.image = image
        return cell
    }
}

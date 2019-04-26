//
//  FeedViewController.swift
//  Momento
//
//  Created by Sam Henry on 2/13/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController {
    
    let testImage1 = #imageLiteral(resourceName: "7R8A0139")
    let testImage2 = #imageLiteral(resourceName: "7R8A9956 2")
    let testImage3 = #imageLiteral(resourceName: "7R8A9987Crop")
    
    var testImages: [UIImage] = []
    
    var userPosts = [feedPost]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerBg: UIView!
    
    @IBOutlet weak var notLoggedImage: UIImageView!
    @IBOutlet weak var notLoggedLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.darkBlack
        
        headerBg.backgroundColor = Colors.lightBlack
        
        self.testImages.append(testImage1)
        self.testImages.append(testImage2)
        self.testImages.append(testImage3)
        
        self.collectionView.backgroundColor = UIColor(white: 1, alpha: 0)
        
        let titleImage = UIImage(named: "momentoLettermark")
        let titleImageView = UIImageView(image: titleImage)
        titleImageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = titleImageView
        
        let backButton = UIBarButtonItem()
        backButton.title = " "
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        let currentUserId = Auth.auth().currentUser?.uid
        
        print("CURENT USER", currentUserId)
    
        if currentUserId != nil {
            let currentUserFollowingRef = Database.database().reference().child("Followings").child(currentUserId!).child("Following")
            currentUserFollowingRef.observe(.childAdded, with: {
                snapshot in
                
                print("SNAP", snapshot.key)
                let followerKey = snapshot.key as! String
                
                self.downloadImages(uid: followerKey)
            })
            currentUserFollowingRef.observeSingleEvent(of: .value) {
                (snapshot, error) in
                print("SNAP", snapshot)
//                if snapshot.exists(){
//                    let snapObject = snapshot.value as! NSDictionary
//
//                    var linkArray = [String]()
//
//                    for (key, _) in snapObject {
//                        print("for user", key)
//                        let userLookupID = key as! String
//                        DispatchQueue.main.async {
//                            self.downloadImages(uid: userLookupID)
//                        }
//
//                    }
//                }
            }
        }
    }
    
    func downloadImages(uid: String) {
        print("IN DOWLOAD WITH USER", uid)
        
        let userFollowingContentRef = Database.database().reference().child("Content").child(uid).child("Posts")
        userFollowingContentRef.observe(.childAdded, with: {
            snapshot in
            
            //                    print("folling user photos", snapshot.value!)
            let snapObject = snapshot.value as! NSDictionary
            let caption = snapObject["Caption"] as! String
            
            let imageObject = snapObject["Images"] as! NSArray
            var linkArray = [String]()
            
//            print("SNAP", imageObject)
            
            for image in imageObject {
                print("Image", image)
                let imageLink = image as! String
                linkArray.append(imageLink)
                
                let group = DispatchGroup()
                group.enter()
                
                DispatchQueue.global(qos: .background).async {
                    let storageRef = Storage.storage().reference(forURL: imageLink)
                    storageRef.downloadURL {
                        (url, error) in
                        
                        print("URL", url!)
                        
                        if let data = try? Data(contentsOf: url!){
                            if let image = UIImage(data: data){
                                self.userPosts.append(feedPost(uid: uid, image: image, caption: caption))
                            }
                        }
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    print("DOWNLOAD COMPLETE")
                    self.collectionView.reloadData()
                }
            }
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //self.navigationController?.view.backgroundColor = Colors.darkYellow
        let currentUserId = Auth.auth().currentUser?.uid

        if currentUserId == nil {
            self.notLoggedImage.image = UIImage(named: "MomentoLogo")
            self.notLoggedLabel.text = "Please Signup or login on Profile page!"
        }else{
            self.notLoggedImage.image = UIImage()
            self.notLoggedLabel.text = ""
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FeedDetail"{
            let selectedImage = collectionView?.indexPath(for: sender as! FeedCollectionViewCell)
            let feedDetail = segue.destination as! FeedDetailViewController
            
            feedDetail.incomingImage = userPosts[selectedImage!.row].image
            feedDetail.incomingCaption = userPosts[selectedImage!.row].caption
            feedDetail.incomingUID = userPosts[selectedImage!.row].uid
        }
    }

}
extension FeedViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = self.userPosts[indexPath.item].image
        let height = (image.size.height)/10
        
        return height
        
    }
    
    
}
extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCollectionCell", for: indexPath) as! FeedCollectionViewCell
        
        let image = userPosts[indexPath.row].image
//        print("IMAGE", image)
        cell.imageCell.image =  image
        
        return cell
    }
}

class feedPost {
    let uid: String
    let image: UIImage
    let caption: String
    
    init(uid: String, image: UIImage, caption: String){
        self.uid = uid
        self.image = image
        self.caption = caption
    }
}

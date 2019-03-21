//
//  ProfileViewController.swift
//  Momento
//
//  Created by Sam Henry on 3/5/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import Photos

class ProfileViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var userImages = [UIImage]()
    
    @IBAction func importBtn(_ sender: UIButton) {
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated: true){
            print("Upload comeplete")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var imageName = ""
        
        
        
//        if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
//            let assetResources = PHAssetResource.assetResources(for: asset)
//
//            print("FILENAME", assetResources.first!.originalFilename)
//
//            imageName = assetResources.first!.originalFilename
//        }else{
//            print("error getting filename")
//        }
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            print("image", image)
            
            guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
            
            let imageMetaData = StorageMetadata()
            imageMetaData.contentType = "image/jpg"
            
            
            let uid = Auth.auth().currentUser!.uid
            let contentStorageRef = Storage.storage().reference().child(uid).child("images")
            let contentDBRef = Database.database().reference().child("Content").child(uid).child("Images")
            
            let postID = UUID().uuidString
            print(postID)
            
            
            let uploadTask = contentStorageRef.child(postID).putData(imageData, metadata: imageMetaData) { (metaData, error) in
                
                if error != nil{
                    print("ADD ALERT for failed upload")
                }else{
                    print("Upload Complete!")
                    contentStorageRef.child(postID).downloadURL {
                        (imgURL, error) in
                        
                        if error != nil{
                            print("ADD ALERT for errors")
                        }else{
                            print("URL:", imgURL!)
                            let downloadUrl = imgURL?.absoluteString
                            contentDBRef.child(postID).setValue(downloadUrl)
                        }
                    }
                }
            }
            uploadTask.observe(.progress) { (snapshot) in
                print(snapshot.progress ?? "NO MORE PROGRESS")
            }
            
        }else{
            print("ADD ALERT for failures")
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func logoutBtn(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
            print("signed out")
            self.performSegue(withIdentifier: "LogoutProfileSegue", sender: self)
        }catch{
            print("error signing out")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        let uid = Auth.auth().currentUser!.uid
        let contentDBRef = Database.database().reference().child("Content").child(uid).child("Images")
        
        print("userInfo", self.userImages)
        
        print("view will appear")
        
        contentDBRef.observe(.childAdded, with: {
            (snapshot) in
            
            //            print("child added")
            print("SNAPSHOT", snapshot)
            
            
            let downloadLink = snapshot.value as! String

            self.getUserImages(downloadLink: downloadLink)

            print("USER IAMGES", self.userImages)
            
        })
    }
    
    func getUserImages(downloadLink: String) {
        print("download link", downloadLink)
        let uid = Auth.auth().currentUser!.uid
        let contentDBRef = Database.database().reference().child("Content").child(uid).child("Images")
        
        let storageRef = Storage.storage().reference(forURL: downloadLink)
        storageRef.downloadURL(completion: { (url, error) in
            do{
                let data = try Data(contentsOf: url!)

                let newImage = UIImage(data: data as Data)
                
//                self.userImages.removeAll()

                DispatchQueue.main.async {
                    self.displayImages(image: newImage!)
                }

            }catch{
                print("error with data")
            }
        })
        
        
//        contentDBRef.observeSingleEvent(of: .value, with: {(snapshot) in
//
//            for item in snapshot.children.allObjects as! [DataSnapshot]{
//                print("ITEM", item)
//
//                let downloadLink = item.value as! String
//                let storageRef = Storage.storage().reference(forURL: downloadLink)
//
//                storageRef.downloadURL(completion: { (url, error) in
//                    do{
//                        let data = try Data(contentsOf: url!)
//
//                        let newImage = UIImage(data: data as Data)
//
//                        DispatchQueue.main.async {
//                            self.displayImages(image: newImage!)
//                        }
//
//                    }catch{
//                        print("error with data")
//                    }
//                })
//            }
//        })
    }
    
    func displayImages(image: UIImage) {
        print("display images", image)
        self.userImages.append(image)
        print("user images", self.userImages)
        
        self.collectionView?.reloadData()
    }
    
    //Setup for collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.userImages.count
        print("count", count)
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgCell", for: indexPath) as! ProfileCollectionViewCell
        
        imageCell.cellImage.image = self.userImages[indexPath.row]
        
        return imageCell
    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgCell", for: indexPath)
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

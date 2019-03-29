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

class ProfileViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate,
                                UIImagePickerControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var headerPhoto: UIImageView!
    
    var userImages = [UIImage]()
    
    let imageCache = NSCache<NSString, UIImage>()
    
    let testImage1 = #imageLiteral(resourceName: "7R8A0139")
    let testImage2 = #imageLiteral(resourceName: "7R8A9956 2")
    let testImage3 = #imageLiteral(resourceName: "7R8A9987Crop")
    
    var testImages: [UIImage] = []
    
    let group = DispatchGroup()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let imageBlur = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: imageBlur)
        blurView.frame = headerPhoto.bounds
        blurView.alpha = 0.6
        headerPhoto.addSubview(blurView)
        
        self.testImages.append(testImage1)
        self.testImages.append(testImage2)
        self.testImages.append(testImage3)
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        let uid = Auth.auth().currentUser!.uid
        let contentDBRef = Database.database().reference().child("Content").child(uid).child("Images")
        
        contentDBRef.observe(.childAdded, with: {
            (snapshot) in
    
            let downloadLink = snapshot.value as! String
            
            let storageRef = Storage.storage().reference(forURL: downloadLink)
            storageRef.downloadURL(completion: {
                (url, error) in
                
                do{
                    let data = try Data(contentsOf: url!)
                    let newImage = UIImage(data: data as Data)
                    
                    print("Image", newImage!)
                    
                    self.userImages.append(newImage!)
                    
                    print("user images", self.userImages)
                    
                    DispatchQueue.main.async {
                        print("reloading")
                        self.collectionView?.reloadData()
                    }
                    
                }catch{
                    print("error with data")
                }
            })
            
        })
    }

}
extension ProfileViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = self.testImages[indexPath.item]
        let height = (image.size.height)/10
        print("height", height)
        return height
    }
}
extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count", self.testImages.count)
        return self.testImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgCell", for: indexPath) as! ProfileCollectionViewCell
        let image = self.testImages[indexPath.row]
        cell.cellImage.image = image
        return cell
    }
    
    
}

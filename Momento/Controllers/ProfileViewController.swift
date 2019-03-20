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
        
        if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
            let assetResources = PHAssetResource.assetResources(for: asset)
            
            print("FILENAME", assetResources.first!.originalFilename)
            
            imageName = assetResources.first!.originalFilename
        }
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
            
            let imageMetaData = StorageMetadata()
            imageMetaData.contentType = "image/jpg"
            
            let imgNameSeperated = imageName.components(separatedBy: ".")
            print("SEPERATED!", imgNameSeperated)
            
            let uid = Auth.auth().currentUser!.uid
            let userContentRef = Storage.storage().reference().child(uid).child("images")
            let contentDBRef = Database.database().reference().child("Users").child(uid).child("Content").child(imgNameSeperated[0])
            
            
            let uploadTask = userContentRef.child(imageName).putData(imageData, metadata: imageMetaData) { (metaData, error) in
                
                if error != nil{
                    print("ADD ALERT for failed upload")
                }else{
                    print("Upload Complete!")
                    userContentRef.child(imageName).downloadURL {
                        (imgURL, error) in
                        
                        if error != nil{
                            print("ADD ALERT for errors")
                        }else{
                            print("URL:", imgURL!)
                            let downloadUrl = imgURL?.absoluteString
                            contentDBRef.setValue(downloadUrl)
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
        
        getUserImages()
    }
    
    func getUserImages() {
        print("getting images")
        let uid = Auth.auth().currentUser!.uid
        let contentDBRef = Database.database().reference().child("Users").child(uid).child("Content")
        
        contentDBRef.observeSingleEvent(of: .value, with: {(snapshot) in
            
            for item in snapshot.children.allObjects as! [DataSnapshot]{
                
                let downloadLink = item.value as! String
                let storageRef = Storage.storage().reference(forURL: downloadLink)
                
                storageRef.downloadURL(completion: { (url, error) in
                    do{
                        let data = try Data(contentsOf: url!)
                        
                        let newImage = UIImage(data: data as Data)
                        
                        DispatchQueue.main.async {
                            self.displayImages(image: newImage!)
                        }
                        
                    }catch{
                        print("error with data")
                    }
                })
            }
        })
    }
    
    func displayImages(image: UIImage) {
        print("display images", image)
        self.userImages.append(image)
        print("user images", self.userImages)
        
        self.collectionView?.reloadData()
    }
    
    //Setup for collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = self.userImages.count
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

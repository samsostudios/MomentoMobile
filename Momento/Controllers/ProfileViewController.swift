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
    
    @IBOutlet weak var usernameField: UILabel!
    
    var imagePickerButtonSelected: String = ""
    let imagePicker = UIImagePickerController()
    
    var username: String = ""
    
    @IBOutlet weak var imageUploadBtn: UIButton!
    
    @IBAction func HeaderBtnUpload(_ sender: UIButton) {
        imagePickerButtonSelected = "header photo"
        
        self.present(imagePicker, animated: true){
            print("Showing picker")
        }
    }
    
    @IBAction func importBtn(_ sender: UIButton) {
        imagePickerButtonSelected = "porfolio image"
        
        self.present(imagePicker, animated: true){
            print("Upload comeplete")
        }
    }
    
    var userImages = [UIImage]()
    
    let imageCache = NSCache<NSString, UIImage>()
    
    let testImage1 = #imageLiteral(resourceName: "7R8A0139")
    let testImage2 = #imageLiteral(resourceName: "7R8A9956 2")
    let testImage3 = #imageLiteral(resourceName: "7R8A9987Crop")
    
    var testImages: [UIImage] = []
    
    let bgImage = UIImageView()
    
    let group = DispatchGroup()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            print("image", image)
            
            guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
            
            let imageMetaData = StorageMetadata()
            imageMetaData.contentType = "image/jpg"
            
            let uid = Auth.auth().currentUser!.uid
            let contentStorageRef = Storage.storage().reference().child(uid).child("images")
            let headerPhotoStorageRef = Storage.storage().reference().child(uid).child("headerPhoto")
            let contentDBRef = Database.database().reference().child("Content").child(uid).child("Images")
            let userInfoDBRef = Database.database().reference().child("Users").child(uid).child("Header Photo")
            
            let postID = UUID().uuidString
            print(postID)
            
            if imagePickerButtonSelected == "header photo" {
                print("header photo button pressed")
                
                let uploadTask = headerPhotoStorageRef.child(postID).putData(imageData, metadata: imageMetaData) {
                    (metaData, error) in
                    
                    if error != nil {
                        print("ADD Alert for failed upload")
                    }else{
                        headerPhotoStorageRef.child(postID).downloadURL {
                            (imgURL, error) in
                            
                            if error != nil {
                                print("ADD ALERT for error downloading")
                            }else{
                                print("URL", imgURL!)
                                
                                let downloadUrl = imgURL?.absoluteString
                                userInfoDBRef.child("Photo Link").setValue(downloadUrl)
                            }
                        }
                    }
                }
                uploadTask.observe(.progress) {
                    (snapshot) in
                    
                    print(snapshot.progress ?? "No more progress")
                }
            }
            if imagePickerButtonSelected == "porfolio image" {
                print("portfolio photo button pressed")
                
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
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        self.navigationController?.isNavigationBarHidden = true
        
        imageUploadBtn.alpha = 0.5
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        
//        setBG()
        self.view.backgroundColor = Colors.darkBlack
        self.collectionView.backgroundColor = UIColor(white: 1, alpha: 0)
        
//        let imageBlur = UIBlurEffect(style: .regular)
//        let blurView = UIVisualEffectView(effect: imageBlur)
//        blurView.frame = headerPhoto.bounds
//        blurView.alpha = 0.6
//        headerPhoto.addSubview(blurView)
        
       
        
        self.testImages.append(testImage1)
        self.testImages.append(testImage2)
        self.testImages.append(testImage3)
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        let uid = Auth.auth().currentUser!.uid
        let headerDBRef = Database.database().reference().child("Users").child(uid).child("headerPhoto")
        let contentDBRef = Database.database().reference().child("Content").child(uid).child("Images")
        let userDBRef = Database.database().reference().child("Users").child(uid)
        
        let usernameRef = Database.database().reference().child("Usernames").child(uid)
        usernameRef.observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            print("SNAP", snapshot)
            
            DispatchQueue.main.async {
                self.username = snapshot.value as! String
                
                print("user", self.username)
            }
        })
        
        userDBRef.observe(.childAdded, with: {
            snapshot in
            
            var username: String = ""
            var designTypes = [String]()
            
            print("SNAPSHOT \(snapshot.key)")
            
            if snapshot.key == "Username"{
                username = snapshot.value as! String
                self.usernameField.text = username
            }
            if snapshot.key == "Header Photo" {
//                print("Header link", snapshot.value!)
                let headerObject = snapshot.value! as! NSDictionary
                var downloadLink: String = ""
                
                for item in headerObject {
                    print(item.value)
                    downloadLink = item.value as! String
                    
                    let headerStorageRef = Storage.storage().reference(forURL: downloadLink)
                    headerStorageRef.downloadURL(completion: {
                        (url, error) in
                        print("header url", url)
                        
                        do {
                            let data = try Data(contentsOf: url!)
                            let headerImage = UIImage(data: data as Data)
                            
                            DispatchQueue.main.async {
                                self.headerPhoto.image = headerImage
                            }
                        }
                        catch {
                            print("Error with header photo")
                        }
                    })
                }
            }
            
//            print("username", username)
        })
        
//        contentDBRef.observe(.childAdded, with: {
//            (snapshot) in
//    
//            let downloadLink = snapshot.value as! String
//            
//            let storageRef = Storage.storage().reference(forURL: downloadLink)
//            storageRef.downloadURL(completion: {
//                (url, error) in
//                
//                print("URL", url)
//                
//                do{
////                    let data = try Data(contentsOf: url!)
////                    let newImage = UIImage(data: data as Data)
////
////                    self.userImages.append(newImage!)
//                    
//                    DispatchQueue.main.async {
////                        print("reloading")
//                        self.collectionView?.reloadData()
//                    }
//                    
//                }catch{
//                    print("error with data")
//                }
//            })
//        })
    }
    
    func setBG (){
        view.addSubview(bgImage)
        bgImage.translatesAutoresizingMaskIntoConstraints = false
        bgImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bgImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bgImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bgImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bgImage.image = UIImage(named: "overlay")
        
        view.sendSubviewToBack(bgImage)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let uid = Auth.auth().currentUser?.uid
        
        print("uid", uid!, "username", username)
        
        if segue.identifier == "showDetail" {
            let imageSelected = collectionView?.indexPath(for: sender as! ProfileCollectionViewCell)
            print("SELECTED IMAGE", type(of: imageSelected!.row))
            let imageDetail = segue.destination as! ProfileDetailViewController
            
            imageDetail.selectedImage = self.testImages[(imageSelected?.row)!]
            print("Username from segue", username)
            imageDetail.username = username
        }
    }
}

// MARK :: Custom Collection view setup
extension ProfileViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = self.testImages[indexPath.item]
        let height = (image.size.height)/10

        return height
    }
}
extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.testImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgCell", for: indexPath) as! ProfileCollectionViewCell
        let image = self.testImages[indexPath.row]
        cell.cellImage.image = image
        return cell
    }
    
    
}

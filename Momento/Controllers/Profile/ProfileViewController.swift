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

class ProfileViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerPhoto: UIImageView!
    @IBOutlet weak var usernameField: UILabel!
    
    var imagePickerButtonSelected: String = ""
    let imagePicker = UIImagePickerController()
    
    var username: String = ""
    var designTypes = [String]()
    var downloadedImageArray = [UIImage]()
    var userPosts = [userPost]()
    
    @IBOutlet weak var imageUploadBtn: UIButton!
    
    @IBAction func HeaderBtnUpload(_ sender: UIButton) {
        print("HEADER SELECTED")
        imagePickerButtonSelected = "header photo"
        
        self.present(imagePicker, animated: true){
            print("Showing picker")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            //            print("image", image)
            
            guard let imageData = image.jpegData(compressionQuality: 0.1) else { return }
            
            let imageMetaData = StorageMetadata()
            imageMetaData.contentType = "image/jpg"
            
            let uid = Auth.auth().currentUser!.uid
            let headerPhotoStorageRef = Storage.storage().reference().child(uid).child("headerPhoto")
            let headerPhotoDBRef = Database.database().reference().child("Header Photos").child(uid)
            
            let postID = UUID().uuidString
            print(postID)
            
            if imagePickerButtonSelected == "header photo" {
                print("header photo button pressed")
                
                let uploadTask = headerPhotoStorageRef.child("Photo").putData(imageData, metadata: imageMetaData) {
                    (metaData, error) in
                    
                    if error != nil {
                        print("ADD Alert for failed upload")
                    }else{
                        headerPhotoStorageRef.child("Photo").downloadURL {
                            (imgURL, error) in
                            
                            if error != nil {
                                print("ADD ALERT for error downloading")
                            }else{
//                                print("URL", imgURL!)
                                
                                let downloadUrl = imgURL?.absoluteString
                                headerPhotoDBRef.child("Photo").setValue(downloadUrl)
                            }
                        }
                    }
                }
                uploadTask.observe(.progress) {
                    (snapshot) in
                    
                    print(snapshot.progress ?? "No more progress")
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
        setNavBar()
        imageUploadBtn.alpha = 0.5
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let backButton = UIBarButtonItem()
        backButton.title = " "
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

        self.view.backgroundColor = Colors.darkBlack
        self.collectionView.backgroundColor = UIColor(white: 1, alpha: 0)
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        let uid = Auth.auth().currentUser!.uid
        let contentDBRef = Database.database().reference().child("Content").child(uid).child("Posts")
        let userDBRef = Database.database().reference().child("Users").child(uid)
        let headerPhotoDBRef = Database.database().reference().child("Header Photos").child(uid)
        
        headerPhotoDBRef.observeSingleEvent(of: .value) {
            snapshot in
            
            let snap = snapshot.children.allObjects
            
            if snap.isEmpty {
//                print("No header photo")
                self.headerPhoto.image = UIImage(named: "image1")
                
            }else{
//                print("Header photo")
                let downloadObject = snapshot.value as! NSDictionary
                
                for item in downloadObject {
                    let downloadLink = item.value as! String
                    
                    let headerStorageRef = Storage.storage().reference(forURL: downloadLink)
                    headerStorageRef.downloadURL(completion: {
                        (url, error) in
                        
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
        }
        
        headerPhotoDBRef.observe(.childAdded){
            snapshot in
            
//            print("Header SNAP", snapshot.value!)
            let downloadLink = snapshot.value! as! String
            
            let headerStorageRef = Storage.storage().reference(forURL: downloadLink)
            headerStorageRef.downloadURL(completion: {
                (url, error) in
                
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
        
        headerPhotoDBRef.observe(.childChanged, with: {
            snapshot in
            
//            print("SNAP", snapshot.value!)
            let downloadLink = snapshot.value! as! String
            
            let headerStorageRef = Storage.storage().reference(forURL: downloadLink)
            headerStorageRef.downloadURL(completion: {
                (url, error) in
                
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
        })
        
        userDBRef.observe(.childAdded, with: {
            snapshot in
            
            var username: String = ""
            
//            print("SNAPSHOT \(snapshot.key)")
            
            if snapshot.key == "Username"{
                username = snapshot.value as! String
                self.usernameField.text = username
                self.username = username
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
//                        print("header url", url!)

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
            if snapshot.key == "Design Types" {
                let typesObejct = snapshot.value as! NSDictionary
                
                for item in typesObejct {
//                    print("TYPE", item.key)
                    self.designTypes.append(item.key as! String)
                }
            }
        })

        
        contentDBRef.observe(.childAdded, with: {
            snapshot in
            
            var linkArray = [String]()

            print("SNAP! in child listen profile", snapshot)

            let snapObject = snapshot.value as! NSDictionary
//            print("SNAP OBJ", snapshot)

//            let caption = "test"
            let caption = snapObject["Caption"] as! String
//            print("CAP", caption)
            
//            print("IMAGES", snapObject["Images"]!)

            let imageObject = snapObject["Images"] as! NSArray
//            print("IMG OBJ", imageObject)

            for image in imageObject {
//                print("Image", image)
                let imageLink = image as! String
                linkArray.append(imageLink)
            }

            self.downloadImages(caption: caption, dlLinks: linkArray)

        })

        
    }
    
    func downloadImages(caption: String, dlLinks: [String]) {
        print("IN DOWLOAD")
        print("caption", caption)
        
        let profileImageLink = dlLinks.first as! String
        
        var imageHolder = userPost(caption: "", image: UIImage())
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.main.async {
            print("Downloading")
            let storageRef = Storage.storage().reference(forURL: profileImageLink)
            storageRef.downloadURL {
                (url, error) in
                
                if let data = try? Data(contentsOf: url!) {
                    if let image = UIImage(data: data){
                        imageHolder = userPost(caption: caption, image: image)
                        self.userPosts.append(imageHolder)
                        
                    }
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main){
            print("download finished")
            print("HOLDER cap", imageHolder.caption, "image", imageHolder.image)
            print("user posts", self.userPosts)
//            print("USER POSTS", self.userPosts)
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.reloadData()
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        setNavBar()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
//        self.collectionView.reloadData()
    }
    
    func setNavBar(){
        //      Navigation Bar Styling
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let uid = Auth.auth().currentUser?.uid

        if uid == nil {
            print("no user")
        }else{
            print("uid", uid!, "username", username)

            if segue.identifier == "showDetail" {
                let imageSelected = collectionView?.indexPath(for: sender as! ProfileCollectionViewCell)
//                print("SELECTED IMAGE", imageSelected!.row)
                let imageDetail = segue.destination as! ProfileDetailViewController

                imageDetail.selectedImage = self.userPosts[(imageSelected?.row)!].image
//                print("Username from segue", username)
                imageDetail.username = username
//                print("TYPES", self.designTypes)
                imageDetail.caption = self.userPosts[imageSelected!.row].caption
                imageDetail.types = self.designTypes

            }
        }
    }
}

// MARK :: Custom Collection view setup
extension ProfileViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
//        print("gettting image height")
        let image = self.userPosts[indexPath.item].image
        let height = (image.size.height)/10

        return height
    }
}
extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count", self.userPosts.count)
        return self.userPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        print("drawing cell", self.userPosts[indexPath.row].image)
        print("USER POST", self.userPosts[indexPath.row].image)

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgCell", for: indexPath) as! ProfileCollectionViewCell
        
        let image = userPosts[indexPath.row].image
        print("setting image", image)
        cell.cellImage.image = image

        return cell
    }
}

class userPost {
    let caption: String
    let image: UIImage
    
    init(caption: String, image: UIImage){
        self.caption = caption
        self.image = image
    }
}

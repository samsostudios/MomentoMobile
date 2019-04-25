//
//  UploadCameraRollViewController.swift
//  Momento
//
//  Created by Sam Henry on 4/10/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit
import Firebase
import YPImagePicker
import Photos
import AVFoundation
import AVKit

class UploadCameraRollViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {
    
    var buttonsSelected = [1: false, 2: false, 3: false,
                           4: false, 5: false, 6: false,
                           7: false, 8: false]
    
    var selectedImages = [UIImage]()
    var userDesignTypes = [String]()
    var typesSelected = [String]()
    
    @IBOutlet weak var uploadCollectionView: UICollectionView!
    
    @IBOutlet weak var buttonType1: OnboardButton!
    @IBAction func button1Selected(_ sender: UIButton) {
        buttonsSelected[1] = !buttonsSelected[1]!
        
    }
    @IBOutlet weak var buttonType2: OnboardButton!
    @IBAction func button2Selected(_ sender: UIButton) {
        buttonsSelected[2] = !buttonsSelected[2]!
    }
    @IBOutlet weak var buttonType3: OnboardButton!
    @IBAction func button3Selected(_ sender: UIButton) {
        buttonsSelected[3] = !buttonsSelected[3]!
    }
    @IBOutlet weak var buttonType4: OnboardButton!
    @IBAction func button4Selected(_ sender: UIButton) {
        buttonsSelected[4] = !buttonsSelected[4]!
    }
    @IBOutlet weak var buttonType5: OnboardButton!
    @IBAction func button5Selected(_ sender: Any) {
        buttonsSelected[5] = !buttonsSelected[5]!
    }
    @IBOutlet weak var buttonType6: OnboardButton!
    @IBAction func button6Selected(_ sender: Any) {
        buttonsSelected[6] = !buttonsSelected[6]!
    }
    @IBOutlet weak var buttonType7: OnboardButton!
    @IBAction func button7Selected(_ sender: UIButton) {
        buttonsSelected[7] = !buttonsSelected[7]!
    }
    @IBOutlet weak var buttonType8: OnboardButton!
    @IBAction func button8Selected(_ sender: UIButton) {
        buttonsSelected[8] = !buttonsSelected[8]!
    }
    @IBOutlet weak var buttonType9: OnboardButton!

    
    @IBOutlet weak var commentView: UITextView!
    
    @IBAction func uploadButton(_ sender: UIBarButtonItem) {
        var postTypes = [String]()
        var caption =  ""
        var uploadImages = [String]()
        
        print("SELECTED IMAGES", self.selectedImages )
        
        if commentView.text == "Add Caption" || commentView.text == "" {
            caption = ""
        }else{
            caption = commentView.text
        }
        
        for (key, value) in buttonsSelected {
            if value == true{
                switch key {
                case 1:
                    //                    print(buttonType1.titleLabel!.text!)
                    postTypes.append(buttonType1.titleLabel!.text!)
                case 2:
                    postTypes.append(buttonType2.titleLabel!.text!)
                case 3:
                    postTypes.append(buttonType3.titleLabel!.text!)
                case 4:
                    postTypes.append(buttonType4.titleLabel!.text!)
                case 5:
                    postTypes.append(buttonType5.titleLabel!.text!)
                case 6:
                    postTypes.append(buttonType6.titleLabel!.text!)
                case 7:
                    postTypes.append(buttonType7.titleLabel!.text!)
                case 8:
                    postTypes.append(buttonType8.titleLabel!.text!)
                default:
                    print("default")
                }
            }
        }
        
        let uid = Auth.auth().currentUser!.uid
        print("UID", uid)
        let contentDBRef = Database.database().reference().child("Content").child(uid).child("Posts")
        let contentStorageRef = Storage.storage().reference().child(uid).child("images")
        
        let postID = UUID().uuidString
        
        for image in selectedImages{

            let imageID = UUID().uuidString
            print("IMG ID", imageID)

            guard let imageData = image.jpegData(compressionQuality: 0.1) else {return}

            let imageMetaData = StorageMetadata()
            imageMetaData.contentType = "image/jpg"

            let uploadTask = contentStorageRef.child(imageID).putData(imageData, metadata: imageMetaData) {
                (metaData, error) in

                if error != nil {
                    print("ADD ALERT for errors")
                }else{
                    contentStorageRef.child(imageID).downloadURL {
                        (imgURL, error) in

                        if error != nil{
                            print("ADD ALERT for errors", error!)
                        }else{
//                            print("URL:", imgURL!)
                            let downloadUrl = imgURL?.absoluteString
                            uploadImages.append(downloadUrl!)

                            print("selected count", self.selectedImages)
                            print("upload count", uploadImages.count)

                            if self.selectedImages.count == uploadImages.count {
                                print("DOWNLOAD URL COMPLETE")
//                                print("UPLOAD IMAGES", uploadImages)

                                let firbaseUpload = ["Caption": caption, "Types": postTypes, "Images": uploadImages] as [String : Any]
                                print("FIRE UPLOAD", firbaseUpload)

                                contentDBRef.child(postID).setValue(firbaseUpload)
                                
                                self.selectedImages.removeAll()
                                self.uploadCollectionView.reloadData()
                                self.tabBarController?.selectedIndex = 4
                                self.commentView.text = "Add Caption"
//                                for item in self.buttonsSelected {
//                                    print(item.value)
//                                    if item.value == true{
//                                        print("KEY", item.key)
//                                        switch item.key{
//                                        case 1:
//                                            print("button1", self.buttonType1)
//                                        default:
//                                            print("default")
//                                        }
//
//                                    }
//                                }
                                

                            }
                        }
                    }
                }
            }
            uploadTask.observe(.success) {
                snapshot in

                print("UPLOAD COMPLETE", snapshot)
            }

        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        showPicker()
        
        buttonType1.alpha = 0
        buttonType2.alpha = 0
        buttonType3.alpha = 0
        buttonType4.alpha = 0
        buttonType5.alpha = 0
        buttonType6.alpha = 0
        buttonType7.alpha = 0
        buttonType8.alpha = 0
        buttonType9.alpha = 0
        
        //MARK: Get user desgin types
        let uid = Auth.auth().currentUser?.uid
        let designTypesRef = Database.database().reference().child("Users").child(uid!).child("Design Types")
        
        designTypesRef.observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            var count = 1
//            print("SMAP!!!!", snapshot.value!)
//            print("SNAP COUNT", snapshot.children.allObjects.count)
            let snapDict = snapshot.value as! NSDictionary
            for (item, _) in snapDict{
//                print("ITEM", item, "VALUE", value)
//                self.userDesignTypes.append(item as! String)
                let typeToSet = item as! String
                self.setTypeButtonInView(name: typeToSet, item: count)
                
                count = count + 1
            }
        })
        
        print("USERTYPES", self.userDesignTypes)
        
        //MARK: TEXTVIEW SETUP
        commentView.text = "Add Caption"
        commentView.textColor = UIColor.lightGray
        commentView.backgroundColor = Colors.lightBlack
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        self.uploadCollectionView.backgroundColor = UIColor(white: 1, alpha: 0)
        
        let coloredImage = UIImage(named: "overlay")
        UINavigationBar.appearance().setBackgroundImage(coloredImage, for: UIBarMetrics.default)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : Colors.white ]
        UINavigationBar.appearance().tintColor = Colors.white
        
        let backButton = UIBarButtonItem()
        backButton.title = " "
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        self.view.backgroundColor = Colors.darkBlack
    }

    override func viewWillAppear(_ animated: Bool) {
        setNavBar()
    }
    
    // MARK: TEXTVIEW SET UP
    func textViewDidBeginEditing(_ textView: UITextView) {
//        print("editing text view")
        if commentView.textColor == UIColor.lightGray {
            commentView.text = nil
            commentView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
//        print("Text view eneded")
        commentView.resignFirstResponder()
        
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        commentView.resignFirstResponder()
    }

    func openCamera() {
        let cameraController = UIImagePickerController()
        cameraController.delegate = self

        cameraController.sourceType = UIImagePickerController.SourceType.camera
        cameraController.allowsEditing = false
    }

    func openPhotos() {
        let photosController = UIImagePickerController()
        photosController.delegate = self

        photosController.sourceType = UIImagePickerController.SourceType.photoLibrary
        photosController.allowsEditing = true

        self.present(photosController, animated: true) {

        }
    }

    func setNavBar(){
        //      Navigation Bar Styling
        print("Setting navbar")
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear

    }
    
    func showPicker() {
        var config = YPImagePickerConfiguration()
        config.shouldSaveNewPicturesToAlbum = false
        config.startOnScreen = .library
        config.screens = [.library, .photo]
        config.video.libraryTimeLimit = 500.0
        config.wordings.libraryTitle = "Gallery"
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.library.maxNumberOfItems = 3
        config.overlayView?.backgroundColor = Colors.lightBlack
        config.showsFilters = false
        config.showsCrop = .none
        config.bottomMenuItemSelectedColour = Colors.darkYellow
        config.library.spacingBetweenItems = 0.5
        config.colors.tintColor = Colors.darkYellow
        config.colors.multipleItemsSelectedCircleColor = Colors.darkYellow
        config.overlayView = UIView()
        
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            
            if cancelled {
                print("Picker was canceled")
                picker.dismiss(animated: true, completion: nil)
                return
            }
//            _ = items.map { print("🧀 \($0)") }
            
            for item in items{
//                print("ITEM", item)
                switch item {
                case .photo(let photo):
//                    print("PHOTO", photo.image)
                    self.selectedImages.append(photo.image)
                    print("SELECTED IMAGES", self.selectedImages)
                    self.uploadCollectionView.reloadData()
                case .video(let video):
                    print("VIDEO", video)
                }
                
//                print("SELECTED IMAGES", self.selectedImages)
                
                picker.dismiss(animated: true, completion: nil)
            }
            
        }
        present(picker, animated: true, completion: nil)
    }
    
    func setTypeButtonInView(name: String, item: Int){
//        print("TYPE TO SET", name, "NUM", item)
        
        switch item {
        case 1:
            self.buttonType1.text(name)
            self.buttonType1.alpha = 1.0
        case 2:
            self.buttonType2.text(name)
            self.buttonType2.alpha = 1.0
        case 3:
            self.buttonType3.text(name)
            self.buttonType3.alpha = 1.0
        case 4:
            self.buttonType4.text(name)
            self.buttonType4.alpha = 1.0
        case 5:
            self.buttonType5.text(name)
            self.buttonType5.alpha = 1.0
        case 6:
            self.buttonType6.text(name)
            self.buttonType6.alpha = 1.0
        case 7:
            self.buttonType7.text(name)
            self.buttonType7.alpha = 1.0
        case 8:
            self.buttonType8.text(name)
            self.buttonType8.alpha = 1.0
        case 9:
            self.buttonType9.text(name)
            self.buttonType9.alpha = 1.0
        default:
            print("DEfault")
        }
    }

}
extension UploadCameraRollViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("COUNT", self.selectedImages.count)
        return self.selectedImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = uploadCollectionView.dequeueReusableCell(withReuseIdentifier: "UploadCollectionItem", for: indexPath) as! UploadCollectionViewCell

        cell.uploadImageView.image = self.selectedImages[indexPath.row]

        return cell
    }


}

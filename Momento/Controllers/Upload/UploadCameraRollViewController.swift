//
//  UploadCameraRollViewController.swift
//  Momento
//
//  Created by Sam Henry on 4/10/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit
import Firebase

class UploadCameraRollViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.darkBlack
        
        
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.sourceType = UIImagePickerControllerS
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Photos", style: .default, handler: { _ in
            self.openPhotos()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            guard let imageData = image.jpegData(compressionQuality: 0.1) else { return }
            
            let imageMetaData = StorageMetadata()
            imageMetaData.contentType = "image/jpg"
            
            let uid = Auth.auth().currentUser!.uid
            let contentStorageRef = Storage.storage().reference().child(uid).child("images")
            let contentDBRef = Database.database().reference().child("Content").child(uid).child("Images")
            
            let postID = UUID().uuidString
            print(postID)
            
            
        }else{
            print("ADD ALERT for failures")
        }
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        print("IN PICKER")
//        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
//
////            guard let imageData = image.jpegData(compressionQuality: 0.1) else { return }
////
////            let imageMetaData = StorageMetadata()
////            imageMetaData.contentType = "image/jpg"
////
////            let uid = Auth.auth().currentUser!.uid
////            let contentStorageRef = Storage.storage().reference().child(uid).child("images")
////            let contentDBRef = Database.database().reference().child("Content").child(uid).child("Images")
////
////            let postID = UUID().uuidString
////            print(postID)
////
////            let uploadTask = contentStorageRef.child(postID).putData(imageData, metadata: imageMetaData) { (metaData, error) in
////
////                if error != nil{
////                    print("ADD ALERT for failed upload")
////                }else{
////                    print("Upload Complete!")
////                    contentStorageRef.child(postID).downloadURL {
////                        (imgURL, error) in
////
////                        if error != nil{
////                            print("ADD ALERT for errors")
////                        }else{
////                            print("URL:", imgURL!)
////                            let downloadUrl = imgURL?.absoluteString
////                            contentDBRef.child(postID).setValue(downloadUrl)
////                        }
////                    }
////                }
////            }
////            uploadTask.observe(.progress) { (snapshot) in
////                print(snapshot.progress ?? "NO MORE PROGRESS")
////            }
//        }else{
//            print("ADD ALERT for failures")
//        }
//
//        self.dismiss(animated: true, completion: nil)
//
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

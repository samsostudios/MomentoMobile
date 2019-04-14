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
    
    let testImage1 = #imageLiteral(resourceName: "7R8A9956-2")
    let testImage2 = #imageLiteral(resourceName: "7R8A9956 2")
    let testImage3 = #imageLiteral(resourceName: "image1")
    
    var testImages: [UIImage] = []
    
    var selectedImages = [UIImage]()
    var selectedItems = [YPMediaItem]()
    
    let pickerNavColor = Colors.lightBlack
    var importedImage = UIImage()
    
    @IBOutlet weak var commentView: UITextView!
    
    @IBAction func uploadButton(_ sender: UIBarButtonItem) {
        print("UPLOAD CLICKED")
    }
    @IBOutlet weak var uploadCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showPicker()
        
        commentView.text = "Placeholder"
        commentView.textColor = UIColor.lightGray
        commentView.backgroundColor = Colors.white.withAlphaComponent(0.5)
        
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("editing text view")
        if commentView.textColor == UIColor.lightGray {
            commentView.text = nil
            commentView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("Text view eneded")
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
            _ = items.map { print("🧀 \($0)") }
            
            for item in items{
//                print("ITEM", item)
                switch item {
                case .photo(let photo):
                    print("PHOTO", photo.image)
                    self.selectedImages.append(photo.image)
                    self.uploadCollectionView.reloadData()
                case .video(let video):
                    print("VIDEO", video)
                }
                
                print("SELECTED IMAGES", self.selectedImages)
                
                picker.dismiss(animated: true, completion: nil)
            }
            
        }
        present(picker, animated: true, completion: nil)
    }

}
extension UploadCameraRollViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("COUNT", self.selectedImages.count)
        return self.selectedImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = uploadCollectionView.dequeueReusableCell(withReuseIdentifier: "UploadCollectionItem", for: indexPath) as! UploadCollectionViewCell

        cell.uploadImageView.image = self.selectedImages[indexPath.row]

        return cell
    }


}

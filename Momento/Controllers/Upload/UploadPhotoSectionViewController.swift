//
//  UploadPhotoSectionViewController.swift
//  Momento
//
//  Created by Sam Henry on 4/12/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit

class UploadPhotoSectionViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        

        // Do any additional setup after loading the view.
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "returnToUploadSegue" {
//            let sendImageToUpload = segue.destination as! UploadCameraRollViewController
//
//            sendImageToUpload.importedImage = imageSelected
//        }
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

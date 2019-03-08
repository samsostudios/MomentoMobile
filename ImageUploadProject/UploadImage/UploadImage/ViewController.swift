//
//  ViewController.swift
//  UploadImage
//
//  Created by Joshua Griffiths on 3/8/19.
//  Copyright © 2019 joshuaGriffiths. All rights reserved.
//

import UIKit
import FirebaseStorage

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBOutlet weak var uploadImage: UIImageView!//From Main.Storyboard
    @IBOutlet weak var downloadImage: UIImageView!
    
    let filename = "earth.jpg"//name of the file that will appear in the database
    
    var imageReference: StorageReference {
        return Storage.storage().reference().child("images")//create a bucket in database to store image
    }
    
    @IBAction func onUploadTapped() {
        guard let image = uploadImage.image else { return }//refrence image from Main.storyboard
        guard let imageData = UIImageJPEGRepresentation(image, 1) else { return }//whats going to be actually uploaded
        
        let uploadImageRef = imageReference.child(filename)//where were gonna store the image data (in somethign called earth.jpg
        
        let uploadTask = uploadImageRef.putData(imageData, metadata: nil) { (metadata, error) in
            print("UPLOAD TASK FINISHED")
            print(metadata ?? "NO METADATA")
            print(error ?? "NO ERROR")
        }//upload the image
        
        uploadTask.observe(.progress) { (snapshot) in
            print(snapshot.progress ?? "NO MORE PROGRESS")
        }//logging
        
        uploadTask.resume()//resume after printing
        
    }
    
    @IBAction func onDownloadTapped() {
        let downloadImageRef = imageReference.child(filename)//where were gonna get the data from
        
        let downloadtask = downloadImageRef.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
            if let data = data {
                let image = UIImage(data: data)
                self.downloadImage.image = image
            }//get the data from firebase
            print(error ?? "NO ERROR")
        }
        
        downloadtask.observe(.progress) { (snapshot) in
            print(snapshot.progress ?? "NO MORE PROGRESS")
        }
        
        downloadtask.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


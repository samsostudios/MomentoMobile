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
    
    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var downloadImage: UIImageView!
    
    let filename = "earth.jpg"
    
    var imageReference: StorageReference {
        return Storage.storage().reference().child("images")
    }
    
    @IBAction func onUploadTapped() {
        guard let image = uploadImage.image else { return }
        guard let imageData = UIImageJPEGRepresentation(image, 1) else { return }
        
        let uploadImageRef = imageReference.child(filename)
        
        let uploadTask = uploadImageRef.putData(imageData, metadata: nil) { (metadata, error) in
            print("UPLOAD TASK FINISHED")
            print(metadata ?? "NO METADATA")
            print(error ?? "NO ERROR")
        }
        
        uploadTask.observe(.progress) { (snapshot) in
            print(snapshot.progress ?? "NO MORE PROGRESS")
        }
        
        uploadTask.resume()
        
    }
    
    @IBAction func onDownloadTapped() {
        let downloadImageRef = imageReference.child(filename)
        
        let downloadtask = downloadImageRef.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
            if let data = data {
                let image = UIImage(data: data)
                self.downloadImage.image = image
            }
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


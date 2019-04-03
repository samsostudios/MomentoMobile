//
//  CommunityDetailViewController.swift
//  Momento
//
//  Created by Sam Henry on 4/2/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit
import Firebase

class CommunityDetailViewController: UIViewController {
    
    var comName = ""
    var comDesc = ""
    
    let testImage1 = #imageLiteral(resourceName: "7R8A0139")
    let testImage2 = #imageLiteral(resourceName: "7R8A9956 2")
    let testImage3 = #imageLiteral(resourceName: "7R8A9987Crop")
    
    var testImages: [UIImage] = []
    
    var isMember = Bool()

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func joinButtonPressed(_ sender: UIButton) {
        var members = [String]()
        
        let uid = (Auth.auth().currentUser?.uid)!
        let communitiesMembersDBRef = Database.database().reference().child("Communities").child(comName).child("Members")
        
        communitiesMembersDBRef.observeSingleEvent(of: .value, with: {
            snapshot in
            
            print("SNAP!!!", snapshot)
            let membersObject = snapshot.value as! NSDictionary
            for item in membersObject {
                print("item", item)
                
                DispatchQueue.main.async {
                    members.append(item.key as! String)
                    print("MEMBERS", members)
                    
                    if members.contains(uid){
                        print("IS MEMBER")
                    }else{
                        print("NOT MEMBER")
                        
                        communitiesMembersDBRef.child(uid).setValue("True")
                    }
                }
            }
            
        })
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.darkBlack
        self.collectionView.backgroundColor = UIColor(white: 1, alpha: 0)
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        self.testImages.append(testImage1)
        self.testImages.append(testImage2)
        self.testImages.append(testImage3)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        print("DATA IN DETAIL!", comName, ",", comDesc)
        
        nameLabel.text  = "Welcome to " + comName
        descLabel.text = comDesc
        
        joinButton.layer.cornerRadius = 25
        joinButton.clipsToBounds = true
        
    }
}
extension CommunityDetailViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = testImages[indexPath.item]
        let height = (image.size.height)/10
        
        return height
    }
    
    
}
extension CommunityDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommunityCollectionCell", for: indexPath) as! CommunityDetailCollectionViewCell
        let image = testImages[indexPath.row]
        cell.cellImage.image = image
        
        return cell
    }
    
    
}

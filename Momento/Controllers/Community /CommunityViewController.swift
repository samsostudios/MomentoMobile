//
//  CommunityViewController.swift
//  Momento
//
//  Created by Sam Henry on 2/13/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit
import Firebase

class CommunityViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var communityCollectionView: UICollectionView!
    
    var communityNames = [String]()
    var communityArray = [communities]()
    
    override func viewDidLoad() {
        print("community did load")
        super.viewDidLoad()
        self.view.backgroundColor = Colors.darkBlack
        
        self.communityCollectionView.backgroundColor = UIColor(white: 1, alpha: 0)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let backButtonImage = UIImage(named: "backBlack")
        self.navigationController?.navigationBar.backIndicatorImage = backButtonImage
    
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        
        let backButton = UIBarButtonItem()
        backButton.title = " "
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        let communitiesDBRef = Database.database().reference().child("Communities")
        print("communtiy ref", communitiesDBRef)
        communitiesDBRef.observe(.childAdded, with: {
            snapshot in
            
            var cName = ""
            var cDescription = ""
//            print("SNAP!!!", snapshot.value!)
            
            self.communityNames.append(snapshot.key)
            cName = snapshot.key
            
            let communityObject = snapshot.value as! NSDictionary
            for item in communityObject {
                print("ITEM", item.key)
                let itemTag = item.key as! String
                
                if itemTag == "Description" {
                    print("item value", item.value)
                    cDescription = item.value as! String
                }
                
                
            }
            
            DispatchQueue.main.async {
                self.communityArray.append(communities(communityName: cName, communityDescriptions: cDescription))
                self.communityCollectionView.reloadData()
            }
            
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommunityDetail" {
            let imageSelected = communityCollectionView?.indexPath(for: sender as! CommuniytCollectionViewCell)
            
            let communityDetail = segue.destination as! CommunityDetailViewController
            
            communityDetail.comName = communityArray[(imageSelected?.row)!].communityName
            
            communityDetail.comDesc = communityArray[(imageSelected?.row)!].communityDescriptions
            
            print("SELECTED IMAGE", type(of: imageSelected!.row))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return communityArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = communityCollectionView.dequeueReusableCell(withReuseIdentifier: "CommunityCell", for: indexPath) as! CommuniytCollectionViewCell
        let communityName = communityArray[indexPath.row].communityName
        cell.communityName.text = communityName
        
        let communityDescription = communityArray[indexPath.row].communityDescriptions
        cell.communityDescription.text = communityDescription
        
        return cell
    }
}

class communities {
    let communityName: String
    let communityDescriptions: String
    
    init(communityName: String, communityDescriptions: String) {
        self.communityName = communityName
        self.communityDescriptions = communityDescriptions
    }
}



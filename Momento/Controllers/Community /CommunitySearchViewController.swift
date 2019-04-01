//
//  CommunitySearchViewController.swift
//  Momento
//
//  Created by Sam Henry on 3/31/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit
import Firebase

class CommunitySearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var initialUsernamesForSearch = [String]()
    var usernamesAfterFilter = [String]()
    var userPhoto = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.darkBlack

        // NAV Setup
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        //TableView Setup
        self.tableView.backgroundColor = Colors.darkBlack
        self.tableView.separatorColor = Colors.darkYellow
        
        let usernamesDBRef = Database.database().reference().child("Usernames")
        
        usernamesDBRef.observeSingleEvent(of: .value) {
            (snapshot, error) in
            
            if error != nil {
                print("error reading usernames")
            }
            else{
                
                let usernameObject = snapshot.value! as! NSDictionary
                for (uid, username) in usernameObject {
                    
                    self.initialUsernamesForSearch.append(username as! String)
                    self.usernamesAfterFilter = self.initialUsernamesForSearch
                    
                    let id = uid as! String
                    print("ID", id)
                    
                    let headerPhotoDBRef = Database.database().reference().child("Header Photos").child(id).child("Photo")
                    headerPhotoDBRef.observeSingleEvent(of: .value) {
                        snapshot in
                        
                        print("SNAP", snapshot.value!)
                        let downloadLink = snapshot.value! as! String
                        
                        if downloadLink != nil{
                            print("GETTING USER PHOTOS")
                            let headerStorageRef = Storage.storage().reference(forURL: downloadLink)
                            headerStorageRef.downloadURL(completion: {
                                (url, error) in
                                
                                do {
                                    let data = try Data(contentsOf: url!)
                                    let headerImage = UIImage(data: data as Data)
                                    
                                    self.userPhoto.append(headerImage!)
                                    
                                    DispatchQueue.main.async {
                                        print("Reloading")
                                        self.tableView.reloadData()
                                    }

                                }
                                catch {
                                    print("Error with header photo")
                                }
                            })
                        }else{
                            print("NOT GETTING PHOTOS")
                        }
                    }
//                    let headerPhotoDBRef = Database.database().reference().child("Users").child(id).child("Header Photo")
////                    print("LINK", headerPhotoDBRef)
//                    var downloadLink: String = ""
//
//                    headerPhotoDBRef.observeSingleEvent(of: .value) {
//                        (snapshot, error) in
//
//                        if error != nil{
//                            print("error downloading header photo")
//                        }else{
//                            let dlObject = snapshot.value as! NSDictionary
//                            for link in dlObject {
//                                downloadLink = link.value as! String
//                            }
//                            print("SNAP", dlObject)
//                            print("link", downloadLink)
//                        }
//                    }

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("count", self.usernamesAfterFilter.count)
        return usernamesAfterFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchTableView") as! CommunitySearchTableViewCell
        
//        print("user photos", self.userPhoto[indexPath.row])
        
        var image = UIImage()
        
        if self.userPhoto.count == 0 {
            print("no current images")
        }else{
            image = self.userPhoto[indexPath.row]
        }
        
        cell.backgroundColor = UIColor.clear
        cell.usernameLabel.text = self.usernamesAfterFilter[indexPath.row]
        cell.userImage.image = image
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
}

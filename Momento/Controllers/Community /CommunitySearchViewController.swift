//
//  CommunitySearchViewController.swift
//  Momento
//
//  Created by Sam Henry on 3/31/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit
import Firebase

class CommunitySearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var userArray = [users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.darkBlack

        self.searchBar.delegate = self
        
        // NAV Setup
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        let backButton = UIBarButtonItem()
        backButton.title = " "
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
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
                    
                    //Vars for storing data
                    var uidStore = ""
                    var usernameStore = ""
                    var userImageStore = UIImage()
                    
                    usernameStore = username as! String
                    
                    let id = uid as! String
//                    print("ID", id))
                    
                    uidStore = id
                    
                    
                    let headerPhotoDBRef = Database.database().reference().child("Header Photos").child(id).child("Photo")
                    headerPhotoDBRef.observeSingleEvent(of: .value) {
                        snapshot in
                        
                        
//                        print("SNAP", snapshot.value!)
                        let downloadLink = snapshot.value! as! String
                        print("DL LINK", downloadLink)
                        
                        if downloadLink != nil{
                            print("GETTING USER PHOTOS")
                            let headerStorageRef = Storage.storage().reference(forURL: downloadLink)
                            headerStorageRef.downloadURL(completion: {
                                (url, error) in
                                
                                do {
                                    let data = try Data(contentsOf: url!)
                                    let headerImage = UIImage(data: data as Data)
                                    
                                    userImageStore = headerImage!
                                    
                                    DispatchQueue.main.async {
                                        
                                        self.userArray.append(users(uid: uidStore, username: usernameStore, userImage: userImageStore))
                                        
                                        print("USER ARRAY", self.userArray)
                                        
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

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    //MARK: TableView Setup
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("COUNT", self.userArray.count)
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchTableView") as! CommunitySearchTableViewCell
        
        cell.userImage.image = userArray[indexPath.row].userImage
        cell.usernameLabel.text = userArray[indexPath.row].username
        
        cell.backgroundColor = UIColor.clear
//        cell.usernameLabel.text = self.usernamesAfterFilter[indexPath.row]
//        cell.userImage.image = image
        return cell
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let username = usernamesAfterFilter[indexPath.row]
//        print("USERNAME SELECTED", username)
//        let userImage = userPhoto[indexPath.row]
//        let uid = userIdentifiers[indexPath.row]
//        print("ID", uid)
//
//        userDataPassToDetail["uid"] = uid
//        userDataPassToDetail["username"] = username
//        userDataPassToDetail["headerPhoto"] = userImage
//
//        print("USER INFO DICT", userDataPassToDetail)
//
//        performSegue(withIdentifier: "CommunitySeachDetail", sender: self)
//
//    }
    
    //NARK: SearchBar Setup
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print("SEARCH BAR EDITING")
//        guard !searchText.isEmpty else{
//            usernamesAfterFilter = initialUsernamesForSearch
//            print("usernames after filter")
//            tableView.reloadData()
//            return
//        }
//
//        usernamesAfterFilter = initialUsernamesForSearch.filter({ (initialUsernamesForSearch: String) -> Bool in
//            initialUsernamesForSearch.contains(searchText.lowercased())
//
//        })
//
//        tableView.reloadData()
//    }
    
    //MARK: Segue Setup
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "CommunitySeachDetail"{
//            let searchDetail = segue.destination as! SearchDetailViewController
//
//            searchDetail.incomingUserInfo = self.userDataPassToDetail
//        }
//    }
}

class users {
    let uid: String
    let username: String
    let userImage: UIImage
    
    init(uid: String, username: String, userImage: UIImage) {
        self.uid = uid
        self.username = username
        self.userImage = userImage
    }
}

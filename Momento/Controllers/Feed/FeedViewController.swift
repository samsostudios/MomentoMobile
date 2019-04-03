//
//  FeedViewController.swift
//  Momento
//
//  Created by Sam Henry on 2/13/19.
//  Copyright © 2019 Sam Henry. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    let testImage1 = #imageLiteral(resourceName: "7R8A0139")
    let testImage2 = #imageLiteral(resourceName: "7R8A9956 2")
    let testImage3 = #imageLiteral(resourceName: "7R8A9987Crop")
    
    var testImages: [UIImage] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerBg: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.darkBlack
        
        headerBg.backgroundColor = Colors.lightBlack
        
        self.testImages.append(testImage1)
        self.testImages.append(testImage2)
        self.testImages.append(testImage3)
        
        self.collectionView.backgroundColor = UIColor(white: 1, alpha: 0)
        
        let titleImage = UIImage(named: "momentoLettermark")
        let titleImageView = UIImageView(image: titleImage)
        titleImageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = titleImageView
        
        let backButton = UIBarButtonItem()
        backButton.title = " "
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.view.backgroundColor = Colors.darkYellow
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FeedDetail"{
            let selectedImage = collectionView?.indexPath(for: sender as! FeedCollectionViewCell)
            let feedDetail = segue.destination as! FeedDetailViewController
            
            feedDetail.incomingImage = testImages[(selectedImage?.row)!]
        }
    }

}
extension FeedViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = self.testImages[indexPath.item]
        let height = (image.size.height)/10
        
        return height
        
    }
    
    
}
extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCollectionCell", for: indexPath) as! FeedCollectionViewCell
        
        let image = testImages[indexPath.row]
        cell.imageCell.image =  image
        
        return cell
    }
    

}

//
//  ViewController.swift
//  photo-browser-project
//
//  Created by Adi on 10.02.22.
//
import SwiftUI
import UIKit
import Photos
import PhotosUI

class ViewController: UIViewController {
    
    @IBOutlet var collectionViewTwo: UICollectionView!
    @IBOutlet var collectionViewOutlet: UICollectionView!
    @IBOutlet var collectionViewThree: UICollectionView!
    @IBOutlet var collectionViewFour: UICollectionView!
    var photos = [PHAsset]()
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // We have to authorize the PhotoLibrary access and also provide the option in the Info tab for the user to allow us access to the photos
        PHPhotoLibrary.requestAuthorization{[unowned self]
            authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized{
                    print("Access granted")
                    print(self)
                }else{
                    print("Access Denied")
                }
            }
        }
        // Fetching assets and enumerating them with .enumerateObjects() and adding the photos to the Photos array that we created above
        let results = PHAsset.fetchAssets(with: .image, options: nil)
        results.enumerateObjects(){
            (photo: AnyObject, i: Int, bool)-> Void in
            let p = photo as! PHAsset
            self.photos.append(p)
            print(p)
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    // Overriden mehod from CollectionViewDelegate, the actual contents of the Cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    // checking if its the first row and assigning the actual images
        if collectionView == self.collectionViewOutlet{
            // Using our helper method for splitting the images
            let tester = photos.split()
            // Assigning the cell we want to use in this case it is "check"
            let cell = collectionViewOutlet.dequeueReusableCell(withReuseIdentifier: "check", for: indexPath)as? CollectionViewCell
            // Using PHImagemanager and .requestImage for adding the images ( Read Apple Documentation )
            PHImageManager.default().requestImage(for: tester.left[indexPath.row], targetSize: CGSize(width: 300, height: 150), contentMode: .aspectFill, options: nil){
                (img, _) -> Void in
                cell?.backgroundColor = UIColor(patternImage: img!)
            }
            // Adding a corner radius to the cell for a cleaner look
            cell?.layer.cornerRadius = 20
            cell?.image.clipsToBounds = true
            return cell!
        }else if collectionView == self.collectionViewTwo{
            let imgsTwo = photos.split()
            let cellz = collectionViewTwo.dequeueReusableCell(withReuseIdentifier: "checkTwo", for: indexPath)as? CollectionViewCellTwo
            PHImageManager.default().requestImage(for: imgsTwo.leftMid[indexPath.row], targetSize: CGSize(width: 300, height: 190), contentMode: .aspectFill, options: nil){
                (img, _) -> Void in
                cellz?.backgroundColor = UIColor(patternImage: img!)
            }
            cellz?.layer.cornerRadius = 20
            cellz?.imageTwo.clipsToBounds = true
            return cellz!
        }else if collectionView == self.collectionViewThree{
            let imgsThree = photos.split()
            let cellz = collectionViewThree.dequeueReusableCell(withReuseIdentifier: "checkThree", for: indexPath)as? CollectionViewCellThree
            PHImageManager.default().requestImage(for: imgsThree.rightMid[indexPath.row], targetSize: CGSize(width: 300, height: 190), contentMode: .aspectFill, options: nil){
                (img, _) -> Void in
                cellz?.backgroundColor = UIColor(patternImage: img!)
            }
            cellz?.layer.cornerRadius = 20
            cellz?.imageThree.clipsToBounds = true
            return cellz!
        }else{
            let imgsFour = photos.split()
            let cellz = collectionViewFour.dequeueReusableCell(withReuseIdentifier: "checkFuor", for: indexPath)as? CollectionViewCellFour
            PHImageManager.default().requestImage(for: imgsFour.right[indexPath.row], targetSize: CGSize(width: 300, height: 190), contentMode: .aspectFill, options: nil){
                (img, _) -> Void in
                cellz?.backgroundColor = UIColor(patternImage: img!)
            }
            cellz?.layer.cornerRadius = 20
            cellz?.imageFour.clipsToBounds = true
            return cellz!
        }
    }

    // Number of cells we are returning; in this case for different rows, overriden  method for the Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count / 4
    }
}
// Helper method to split an Array, tried different approaches this one seemed to work the best
extension Array{
    func split()->(left:[Element],leftMid:[Element],rightMid:[Element],right:[Element]){
        let count = self.count
        let half = count / 2
        let halfTwo = half / 2
        let countThird = count - halfTwo
        let leftSplit = self[0 ..< halfTwo]
        let leftMid = self[halfTwo ..< half]
        let rightMid = self[half ..< countThird]
        let rightSplit = self[countThird ..< count]
        return (left:Array(leftSplit), leftMid:Array(leftMid), rightMid:Array(rightMid), right:Array(rightSplit))
    }
}

// I also did not use TableView unfortunately, I have tried it multiple times and after it refusing to hold the 4 Collection Views, and after looking at million solutions online, I decided to use the normal views and aligning them myself.

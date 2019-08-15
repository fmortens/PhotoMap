//
//  ImageLocationTableViewController.swift
//  TestApp
//
//  Created by Frank Mortensen on 14/08/2019.
//  Copyright © 2019 Frank Mortensen. All rights reserved.
//

import UIKit
import Photos

struct PhotoRecord {
    
    let photo: UIImage
    let location: CLLocation?
    let identifier: String
    
}

class ImageLocationTableViewController: UITableViewController {
    
    var imageList = [PhotoRecord]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        self.registerTableViewCells()
        
    }

    
    func loadImages(forMomentId momentId: String) {
        
        self.imageList.removeAll()
        
        let fetchOptions = PHFetchOptions()
        let moment = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [momentId], options: fetchOptions)
        
        let fetchAssetsResult = PHAsset.fetchAssets(in: moment.firstObject!, options: fetchOptions)
        
        fetchAssetsResult.enumerateObjects{ ( asset: AnyObject!, count: Int, stop: UnsafeMutablePointer<ObjCBool> ) in
            
            if asset is PHAsset {
                
                let asset: PHAsset = asset as! PHAsset
                
                let manager = PHImageManager.default()
                let options = PHImageRequestOptions()
                var thumbnail = UIImage()
                
                options.isSynchronous = true
                
                manager.requestImage(
                    for: asset,
                    targetSize: CGSize(width: 150, height: 150),
                    contentMode: .aspectFill,
                    options: options
                ) { (image, info) in
                    
                    if let image = image {
                        thumbnail = image
                    }
                }
            
                let photoRecord = PhotoRecord(photo: thumbnail, location: asset.location, identifier: asset.localIdentifier)
                
                self.imageList.append(photoRecord)
                
            }
            
        }
        
        tableView.reloadData()
        
    }
    
    func registerTableViewCells() {
        
        let photoLocationListTableViewCell = UINib(nibName: "PhotoLocationListTableViewCell", bundle: nil)
        
        self.tableView.register(
            photoLocationListTableViewCell,
            forCellReuseIdentifier: "PhotoLocationListTableViewCell"
        )
        
    }
    
    func clearImages() {
        self.imageList.removeAll()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return imageList.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: PhotoLocationListTableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoLocationListTableViewCell") as? PhotoLocationListTableViewCell else {
                
                return PhotoLocationListTableViewCell(
                    style: .default,
                    reuseIdentifier: "PhotoLocationListTableViewCell"
                )
                
            }

            return cell
        }()
        
        let photoRecord = imageList[indexPath.row]
        
        cell.photoView.image = photoRecord.photo
        
        if let location = photoRecord.location {
            CLGeocoder().reverseGeocodeLocation(location) { (placeMarks, error) in
                
                if let placeMark: CLPlacemark = placeMarks?[0] {
                    cell.locationLabel.text = "\(placeMark.name ?? ""), \(placeMark.locality ?? "")"
                }
                
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let bottomSheetController = parent as? BottomSheetViewController {
            if let mapViewController = bottomSheetController.parent as? MapViewController {
                if let topViewController = mapViewController.parent as? MainViewController {
                    
                    topViewController.setPhotoIdentifier(
                        identifier: imageList[indexPath.row].identifier
                    )
                    
                    topViewController.performSegue(
                        withIdentifier: "Show photo",
                        sender: self
                    )
                }
            }

        }
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

//
//  ImageLocationTableViewController.swift
//  TestApp
//
//  Created by Frank Mortensen on 14/08/2019.
//  Copyright © 2019 Frank Mortensen. All rights reserved.
//

import UIKit
import Photos

class ImageLocationTableViewController: UITableViewController {
    
    var imageList = [UIImage]()
    
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
                let option = PHImageRequestOptions()
                var thumbnail = UIImage()
                
                option.isSynchronous = true
                
                manager.requestImage(
                    for: asset,
                    targetSize: CGSize(width: 250, height: 250),
                    contentMode: .aspectFit,
                    options: option,
                    resultHandler: { (result, info) -> Void in
                        thumbnail = result!
                    }
                )
                
                self.imageList.append(thumbnail)
                
            }
            
        }
        
        
            tableView.reloadData()
        
            
        
    }
    
    func registerTableViewCells() {
        
        let photoLocationListTableViewCell = UINib(nibName: "PhotoLocationListTableViewCell", bundle: nil)
        self.tableView.register(photoLocationListTableViewCell, forCellReuseIdentifier: "PhotoLocationListTableViewCell")
        
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
                return PhotoLocationListTableViewCell(style: .default, reuseIdentifier: "PhotoLocationListTableViewCell")
            }

            return cell
        }()
        
        cell.photoView.image = imageList[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

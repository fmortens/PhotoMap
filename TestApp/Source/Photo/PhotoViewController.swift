//
//  PhotoViewController.swift
//  TestApp
//
//  Created by Frank Mortensen on 15/08/2019.
//  Copyright © 2019 Frank Mortensen. All rights reserved.
//

import UIKit
import Photos

class PhotoViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var photoView: UIImageView!
    
    var photoIdentifier: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let fetchOptions = PHFetchOptions()
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [photoIdentifier!], options: fetchOptions)
        
        assets.enumerateObjects { (asset, _, _) in
            
            let options = PHImageRequestOptions()
            options.isNetworkAccessAllowed = true // AAAHA!
            options.deliveryMode = .opportunistic
            options.isSynchronous = true
            options.resizeMode = .exact
            
            let manager = PHImageManager.default()
            manager.requestImage(
                for: asset,
                targetSize: PHImageManagerMaximumSize,
                contentMode: .aspectFit,
                options: options
            ) { (result, info) in
                
                self.photoView.image = result.self
            }
            
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return self.photoView
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

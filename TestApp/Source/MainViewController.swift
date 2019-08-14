//
//  MainViewController.swift
//  TestApp
//
//  Created by Frank Mortensen on 13/08/2019.
//  Copyright © 2019 Frank Mortensen. All rights reserved.
//

import UIKit
import Photos
import CoreData

class MainViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var photoReferences = [PhotoReference]()
    
    override func viewDidLoad() {
        
        let mapViewController = MapViewController()
        
        addChild(mapViewController)
        view.addSubview(mapViewController.view)

        mapViewController.didMove(toParent: self)

        
        /// Load Photos
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                
                self.loadPhotoReferences()
                
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                print("Not determined yet")
            @unknown default:
                fatalError("Do not know what to do")
            }
        }
        
    }
    
    func loadPhotoReferences() {
        
        print("Loading references")
        let request: NSFetchRequest<PhotoReference> = PhotoReference.fetchRequest()
        
        do {
            photoReferences = try context.fetch(request)
            
            if photoReferences.count == 0 {
                print("No references found, creating from photo library")
                self.createPhotoReferences()
            } else {
                print("Loaded references, \(photoReferences.count) loaded")
            }
        } catch {
            print("Error loading photo references \(error)")
        }
        
    }
    
    func createPhotoReferences() {
        
        print("Creating references")
        
        let fetchOptions = PHFetchOptions()
        let photoAssets = PHAsset.fetchAssets(with: .image, options: fetchOptions) as PHFetchResult<PHAsset>
        
        print("Counting \(photoAssets.count ) photos")
        
        photoAssets.enumerateObjects{
            ( object: AnyObject!, count: Int, stop: UnsafeMutablePointer<ObjCBool> ) in
            
            if object is PHAsset{
                let asset = object as! PHAsset
                print("image was created \(String(describing: asset.creationDate))")
                
                if let coordinate = asset.location?.coordinate {
                    let photoReference = PhotoReference(context: self.context)
                    
                    photoReference.localIdentifier = asset.localIdentifier
                    photoReference.creationDate = asset.creationDate
                    photoReference.longitude = Float(coordinate.longitude)
                    photoReference.latitude = Float(coordinate.latitude)
                    
                    self.photoReferences.append(photoReference)
                }
                
            }
        }
        
        do {
            try self.context.save()
        } catch {
            print("Error saving photoReferences \(error)")
        }
        
    }
    
}

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
    var photoMomentReferences = [PhotoMomentReference]()
    
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
        let request: NSFetchRequest<PhotoMomentReference> = PhotoMomentReference.fetchRequest()
        
        do {
            photoMomentReferences = try context.fetch(request)
            
            if photoMomentReferences.count == 0 {
                print("No photoMomentReferences found, creating from photo library")
                self.createPhotoReferences()
            } else {
                print("Loaded references, \(photoMomentReferences.count) loaded")
            }
        } catch {
            print("Error loading photo references \(error)")
        }
        
    }
    
    func createPhotoReferences() {
        
        print("Creating references")
        
        let fetchOptions = PHFetchOptions()
//        let photoAssets = PHAsset.fetchAssets(with: .image, options: fetchOptions) as PHFetchResult<PHAsset>
//
//        print("Counting \(photoAssets.count ) photos")
        
        let collection: PHFetchResult = PHAssetCollection.fetchMoments(with: fetchOptions)
        //PHAssetCollection.fetchAssetCollections(with: .moment, subtype: .any, options: fetchOptions)
        
        collection.enumerateObjects{ ( collection: AnyObject!, count: Int, stop: UnsafeMutablePointer<ObjCBool> ) in
            
                if collection is PHAssetCollection {
                    
                    let moment: PHAssetCollection = collection as! PHAssetCollection
                    
                    if let title = moment.localizedTitle, let coordinate = moment.approximateLocation?.coordinate {
                        
                        let localIdentifier = moment.localIdentifier
                        
                        let photoMomentReference = PhotoMomentReference(context: self.context)
                        photoMomentReference.identifier = localIdentifier
                        photoMomentReference.title = title
                        photoMomentReference.latitude = Float(coordinate.latitude)
                        photoMomentReference.longitude = Float(coordinate.longitude)
                        photoMomentReference.numberOfPhotos = String(moment.estimatedAssetCount)
                        
                        self.photoMomentReferences.append(photoMomentReference)
                    }
                    
                    
//                    let moment = object as! PHMoment
//
//                    print("image was created \(String(describing: moment.creationDate))")
//
                    
            
                }
        }
        
        
        
//        photoAssets.enumerateObjects{
//            ( object: AnyObject!, count: Int, stop: UnsafeMutablePointer<ObjCBool> ) in
//
//            if object is PHAsset{
//                let asset = object as! PHAsset
//                print("image was created \(String(describing: asset.creationDate))")
//
//                if let coordinate = asset.location?.coordinate {
//                    let photoReference = PhotoReference(context: self.context)
//
//                    photoReference.localIdentifier = asset.localIdentifier
//                    photoReference.creationDate = asset.creationDate
//                    photoReference.longitude = Float(coordinate.longitude)
//                    photoReference.latitude = Float(coordinate.latitude)
//
//                    self.photoReferences.append(photoReference)
//                }
//
//            }
//        }
//
        do {
            try self.context.save()
        } catch {
            print("Error saving photoReferences \(error)")
        }
        
    }
    
}


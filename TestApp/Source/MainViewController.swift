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
        let collection: PHFetchResult = PHAssetCollection.fetchMoments(with: fetchOptions)
        
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
            
                }
        }
        
        
        do {
            try self.context.save()
        } catch {
            print("Error saving photoReferences \(error)")
        }
        
    }
    
}


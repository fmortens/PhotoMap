//
//  ViewController.swift
//  TestApp
//
//  Created by Frank Mortensen on 12/08/2019.
//  Copyright © 2019 Frank Mortensen. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var mapDelegate: MKMapViewDelegate?
    var photoMomentReferences = [PhotoMomentReference]()
    var mapAnnotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapDelegate = self
        
        loadPhotoReferences()
        
        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidSave(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    @objc func contextObjectsDidSave(_ notification: Notification) {
        
        let context = notification.object as? NSManagedObjectContext
        
        let request: NSFetchRequest<PhotoMomentReference> = PhotoMomentReference.fetchRequest()
        
        do {
            photoMomentReferences = try context!.fetch(request)
            
            for photoMomentReference in photoMomentReferences {
                
                let lat = CLLocationDegrees(photoMomentReference.latitude)
                let long = CLLocationDegrees(photoMomentReference.longitude)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = ""//photoMomentReference.title
                annotation.subtitle = photoMomentReference.identifier
                
                mapAnnotations.append(annotation)
                
            }
            
            print("Added annotations \(mapAnnotations.count)")
            
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.mapAnnotations)
            }
            
        } catch {
            print("Could not load references from notification \(error)")
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addBottomSheetView()
    }
    
    
    func addBottomSheetView() {
        
        let bottomSheetViewController = BottomSheetViewController()
        bottomSheetViewController.add(toParent: self)
        
        let imageLocationTableViewController = ImageLocationTableViewController()
        bottomSheetViewController.add(content: imageLocationTableViewController)
        
    }
    
    func loadPhotoReferences() {
        
        print("Loading references from map view controller")
        let request: NSFetchRequest<PhotoMomentReference> = PhotoMomentReference.fetchRequest()
        
        do {
            photoMomentReferences = try context.fetch(request)
            
            print("Loaded references, \(photoMomentReferences.count) loaded")
            
            if photoMomentReferences.count > 0 {
                
                for photoMomentReference in photoMomentReferences {
                    
                    let lat = CLLocationDegrees(photoMomentReference.latitude)
                    let long = CLLocationDegrees(photoMomentReference.longitude)
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = ""//photoMomentReference.title
                    annotation.subtitle = photoMomentReference.identifier
                    
                    mapAnnotations.append(annotation)
                    
                }
                
                self.mapView.addAnnotations(mapAnnotations)
                
            }
            
        } catch {
            print("Error loading photo references \(error)")
        }
        
    }

}


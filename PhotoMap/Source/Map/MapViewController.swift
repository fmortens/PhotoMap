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
    
    var photoMomentReferences = [PhotoMomentReference]()
    var mapAnnotations = [MKPointAnnotation]()
    var bottomSheetController: BottomSheetViewController?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mapView.delegate = self
        
        loadPhotoReferences()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contextObjectsDidSave(_:)),
            name: Notification.Name.NSManagedObjectContextDidSave,
            object: nil
        )
        
        addBottomSheetView()
        
    }
    
    
    fileprivate func loadMapAnnotations(_ context: NSManagedObjectContext?) {
        
        let request: NSFetchRequest<PhotoMomentReference> = PhotoMomentReference.fetchRequest()
        
        do {
            photoMomentReferences = try context!.fetch(request)
            
            for photoMomentReference in photoMomentReferences {
                let lat = CLLocationDegrees(photoMomentReference.latitude)
                let long = CLLocationDegrees(photoMomentReference.longitude)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let annotation = MyAnnotation()
                
                annotation.coordinate = coordinate
                annotation.identifier = photoMomentReference.identifier
                
                mapAnnotations.append(annotation)
            }
            
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.mapAnnotations)
            }
            
        } catch {
            print("Could not load references from notification \(error)")
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let annotation = view.annotation as! MyAnnotation
        
        if let bottomSheetController = self.bottomSheetController {
            let imageLocationTableController = bottomSheetController.childController as! ImageLocationTableViewController
            imageLocationTableController.loadImages(forMomentId: annotation.identifier!)
            
            bottomSheetController.showView()
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        if let bottomSheetController = self.bottomSheetController {
            
            let imageLocationTableController = bottomSheetController.childController as! ImageLocationTableViewController
            imageLocationTableController.clearImages()
            
            bottomSheetController.hideView()
        }
        
    }
    
    @objc func contextObjectsDidSave(_ notification: Notification) {
        
        let context = notification.object as? NSManagedObjectContext
        
        loadMapAnnotations(context)
        
    }
    
    
    func addBottomSheetView() {
        
        let bottomSheetViewController = BottomSheetViewController()
        bottomSheetViewController.add(toParent: self)
        
        let imageLocationTableViewController = ImageLocationTableViewController()
        bottomSheetViewController.add(content: imageLocationTableViewController)
        
        self.bottomSheetController = bottomSheetViewController
        
        bottomSheetViewController.hideView()
        
    }
    
    
    func loadPhotoReferences() {
        
        loadMapAnnotations(context)
        
    }
}

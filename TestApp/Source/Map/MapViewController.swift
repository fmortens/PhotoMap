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
    var photoReferences = [PhotoReference]()
    var mapAnnotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapDelegate = self
        
        loadPhotoReferences()
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
        let request: NSFetchRequest<PhotoReference> = PhotoReference.fetchRequest()
        
        do {
            photoReferences = try context.fetch(request)
            
            print("Loaded references, \(photoReferences.count) loaded")
            
            if photoReferences.count > 0 {
                
                for photoReference in photoReferences {
                    
                    let lat = CLLocationDegrees(photoReference.latitude)
                    let long = CLLocationDegrees(photoReference.longitude)
                    
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "Photo taken \(String(describing: photoReference.creationDate))"
                    annotation.subtitle = photoReference.localIdentifier
                    
                    mapAnnotations.append(annotation)
                    
                }
                
                self.mapView.addAnnotations(mapAnnotations)
                
            }
            
        } catch {
            print("Error loading photo references \(error)")
        }
        
    }

}


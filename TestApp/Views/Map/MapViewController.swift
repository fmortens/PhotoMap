//
//  ViewController.swift
//  TestApp
//
//  Created by Frank Mortensen on 12/08/2019.
//  Copyright © 2019 Frank Mortensen. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var mapDelegate: MKMapViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addBottomSheetView()
    }
    
    func addBottomSheetView() {
        
        let bottomSheetViewController = BottomSheetViewController()
        bottomSheetViewController.add(toParent: self)
        
    }

}


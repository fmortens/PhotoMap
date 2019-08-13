//
//  MainViewController.swift
//  TestApp
//
//  Created by Frank Mortensen on 13/08/2019.
//  Copyright © 2019 Frank Mortensen. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        
        let mapViewController = MapViewController()
        
        addChild(mapViewController)
        view.addSubview(mapViewController.view)

        mapViewController.didMove(toParent: self)

    }
    
}

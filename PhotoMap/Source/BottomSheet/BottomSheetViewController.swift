//
//  BottomSheetViewController.swift
//  TestApp
//
//  Created by Frank Mortensen on 13/08/2019.
//  Copyright © 2019 Frank Mortensen. All rights reserved.
//

import UIKit

class BottomSheetViewController: UIViewController {
    
    var childController: UIViewController?
    
    override func viewDidLoad() {
        
        let gesture = UIPanGestureRecognizer.init(
            target: self,
            action: #selector(BottomSheetViewController.panGesture)
        )
        
        view.addGestureRecognizer(gesture)
        
        setupTopBorders()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        prepareBackgroundView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        
    }
    
    func add(toParent parentController: UIViewController) {
        
        parentController.addChild(self)
        parentController.view.addSubview(self.view)
        
        self.didMove(toParent: parentController)
        
    }
    
    func add(content contentController: UIViewController) {
        
        childController = contentController
        
        self.addChild(contentController)
        self.view.addSubview(contentController.view)
        
    }
    
    func prepareBackgroundView() {
        
        let blurEffect = UIBlurEffect.init(style: .regular)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let blurredView = UIVisualEffectView.init(effect: blurEffect)
        
        blurredView.contentView.addSubview(visualEffect)
        visualEffect.frame = UIScreen.main.bounds
        blurredView.frame = UIScreen.main.bounds
        
        view.insertSubview(blurredView, at: 0)
        
    }
    
    func setupTopBorders() {
        
        let radii = 10
        
        let path = UIBezierPath(
            roundedRect: self.view.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radii, height: radii)
        )
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        
        self.view.layer.mask = mask
        
    }
    
    func placeView(withOffset offset: CGFloat, animatedDelay: Double = 0.5) {
        
        UIView.animate (withDuration: animatedDelay) { [weak self] in
            let frame = self?.view.frame
            
            self?.view.frame = CGRect(
                x: 0,
                y: offset,
                width: frame!.width,
                height: frame!.height
            )
        }
        
    }
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        var y = self.view.frame.minY
        
        if y < parent!.view.safeAreaInsets.top {
            y = parent!.view.safeAreaInsets.top
        }
        
        self.view.frame = CGRect(
            x: 0,
            y: y + translation.y,
            width: view.frame.width,
            height: view.frame.height
        )
        
        recognizer.setTranslation(
            CGPoint(
                x: 0,
                y: 0
            ),
            in: self.view
        )
        
        if recognizer.state == .ended {
            
            // Handle quick moves
            if recognizer.velocity(in: self.view).y <= -self.view.frame.height / 3 {
                maximizeView()
            }
                
            else if recognizer.velocity(in: self.view).y > self.view.frame.height / 2 {
                minimizeView()
            }
                
                // Handle slow moves (snap to position)
            else if y > self.view.frame.height / 2 {
                minimizeView()
                
            }
                
            else if y < self.view.frame.height / 2 {
                maximizeView()
                
            }
            
        }
        
    }

    
    func minimizeView() {
        
        childController!.view.isUserInteractionEnabled = false
        
        placeView(
            withOffset: UIScreen.main.bounds.height - 120,
            animatedDelay: 0.25
        )
        
    }
    
    
    func maximizeView() {
        
        childController!.view.isUserInteractionEnabled = true
        
        placeView(withOffset: 64 , animatedDelay: 0.25)
        
    }
    
    
    func hideView() {
        
        UIView.animate (withDuration: 0.3) { [self] in
            
            self.view.frame = CGRect(
                x: 0,
                y: UIScreen.main.bounds.maxY,
                width: self.view.frame.width,
                height: self.view.frame.height
            )
            
        }
        
    }
    
    
    func showView() {
        
        UIView.animate (withDuration: 0.3) { [self] in self.minimizeView() }
        
    }
    
}

//
//  BottomSheetViewController.swift
//  TestApp
//
//  Created by Frank Mortensen on 12/08/2019.
//  Copyright © 2019 Frank Mortensen. All rights reserved.
//

import UIKit

class BottomSheetViewController: UIViewController {
    
    override func viewDidLoad() {
        
        let gesture = UIPanGestureRecognizer.init(
            target: self,
            action: #selector(BottomSheetViewController.panGesture)
        )
        
        view.addGestureRecognizer(gesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        prepareBackgroundView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        minimizeView()
        
    }
    
    func prepareBackgroundView() {
        
        let blurEffect = UIBlurEffect.init(style: .regular)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)

        bluredView.contentView.addSubview(visualEffect)
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds

        view.insertSubview(bluredView, at: 0)
    }
    
    func placeView(withOffset offset: CGFloat, animatedDelay: Double = 0.5) {
        
        UIView.animate(withDuration: animatedDelay) { [weak self] in
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
        let y = self.view.frame.minY
        
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
            if recognizer.velocity(in: self.view).y <= -2000 {
                maximizeView()
            }
            
            else if recognizer.velocity(in: self.view).y > 2000 {
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
        
        placeView(
            withOffset: parent!.view.frame.height - 100,
            animatedDelay: 0.25
        )
        
    }
    
    func maximizeView() {
        
        placeView(withOffset: parent!.view.safeAreaInsets.top , animatedDelay: 0.25)
        
    }

}

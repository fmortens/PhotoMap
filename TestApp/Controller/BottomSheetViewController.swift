//
//  BottomSheetViewController.swift
//  TestApp
//
//  Created by Frank Mortensen on 12/08/2019.
//  Copyright © 2019 Frank Mortensen. All rights reserved.
//

import UIKit

class BottomSheetViewController: UIViewController {
    
    @IBOutlet weak var notchButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        print("Bottom sheet loaded")
        
        let gesture = UIPanGestureRecognizer.init(
            target: self,
            action: #selector(BottomSheetViewController.panGesture)
        )
        
        view.addGestureRecognizer(gesture)
        
        cancelButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        prepareBackgroundView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        placeView(withOffset: UIScreen.main.bounds.height - 64)
        
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
        
        if (recognizer.state == .ended) {
            
            if y > self.view.frame.height / 2 {
                print("Less than half \(y)")
                
                placeView(
                    withOffset: parent!.view.frame.height - 64,
                    animatedDelay: 0.25
                )
            } else if y < self.view.frame.height / 2 {
                print("More than half the screen now")
                
                notchButton.isHidden = true
                
                placeView(withOffset: 0, animatedDelay: 0.25)
                
                cancelButton.isHidden = false
                
            }
        }
        
    }
    
    @IBAction func notchButtonTapped(_ sender: UIButton) {
        
        notchButton.isHidden = true
        
        placeView(withOffset: 0, animatedDelay: 0.3)
        
        cancelButton.isHidden = false
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        
        cancelButton.isHidden = true
        
        placeView(
            withOffset: view.frame.height - 64,
            animatedDelay: 0.3
        )
        
        notchButton.isHidden = false
        
    }
}

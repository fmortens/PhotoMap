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
    
    override func viewDidLoad() {
        print("Bottom sheet loaded")
        
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
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            let frame = self?.view.frame
            let yComponent = UIScreen.main.bounds.height - 200
            self?.view.frame = CGRect(
                x: 0,
                y: yComponent,
                width: frame!.width,
                height: frame!.height
            )
        }
        
    }
    
    func prepareBackgroundView() {
        
//        let blurEffect = UIBlurEffect.init(style: .regular)
//        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
//        let bluredView = UIVisualEffectView.init(effect: blurEffect)
//
//        bluredView.contentView.addSubview(visualEffect)
//        visualEffect.frame = UIScreen.main.bounds
//        bluredView.frame = UIScreen.main.bounds
//
//        view.insertSubview(bluredView, at: 0)
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
                y :0
            ),
            in: self.view
        )
        
    }
    
    @IBAction func notchButtonTapped(_ sender: UIButton) {
        print("Notch tapped")
    }
    
}

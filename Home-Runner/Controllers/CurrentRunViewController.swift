//
//  CurrentRunViewController.swift
//  Home-Runner
//
//  Created by Andrii Zakharenkov on 2/14/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit

class CurrentRunViewController: LocationViewController {

    @IBOutlet weak var sliderBackground: UIImageView!
    @IBOutlet weak var sliderImgView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupGesturesForSlider()
    }
    
    func setupGesturesForSlider() {
        let swipe = UIPanGestureRecognizer(target: self, action: #selector(self.onSwipeAction(sender:)))
        sliderImgView.addGestureRecognizer(swipe)
        sliderImgView.isUserInteractionEnabled = true
        swipe.delegate = self as? UIGestureRecognizerDelegate
    }

    @objc func onSwipeAction(sender: UIPanGestureRecognizer) {
        let minAdjust: CGFloat = 82.5
        let maxAdjust: CGFloat = 128
        
        if let sliderView = sender.view {
            if sender.state == UIGestureRecognizer.State.began || sender.state == UIGestureRecognizer.State.changed {
                let translation = sender.translation(in: self.view)
                
                if sliderView.center.x >= (sliderBackground.center.x - minAdjust) && sliderView.center.x <= (sliderBackground.center.x + maxAdjust) {
                    sliderView.center.x = sliderView.center.x + (translation.x * 0.9)
                } else if sliderView.center.x >= (sliderBackground.center.x + maxAdjust) {
                    sliderView.center.x = sliderBackground.center.x + maxAdjust
                    
                    dismiss(animated: true, completion: nil)
                } else if sliderView.center.x <= (sliderBackground.center.x - minAdjust) {
                    sliderView.center.x = sliderBackground.center.x - minAdjust
                }
                
                sender.setTranslation(CGPoint.zero, in: self.view)
            } else if sender.state == UIGestureRecognizer.State.ended {
                UIView.animate(withDuration: 0.1) {
                    sliderView.center.x = self.sliderBackground.center.x - minAdjust
                }
            }
        }
    }
}

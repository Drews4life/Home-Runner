//
//  CurrentRunViewController.swift
//  Home-Runner
//
//  Created by Andrii Zakharenkov on 2/14/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class CurrentRunViewController: LocationViewController {

    @IBOutlet weak var sliderBackground: UIImageView!
    @IBOutlet weak var sliderImgView: UIImageView!
    
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var paceLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var pauseBtn: UIButton!
    
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var coordLocations = List<Location>()
    var timer = Timer()
    
    var runDistance: Double = 0
    var pace = 0
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupGesturesForSlider()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        manager?.delegate = self
        manager?.distanceFilter = 10
        initiateRun()
    }
    
    func initiateRun() {
        manager?.startUpdatingLocation()
        startTimer()
        pauseBtn.setImage(UIImage(named: "pauseButton"), for: .normal)
    }
    
    func endRun() {
        manager?.stopUpdatingLocation()
        Run.saveRunToRealm(pace: pace, distance: runDistance, duration: counter, locations: coordLocations)
    }
    
    func pauseRun() {
        startLocation = nil
        lastLocation = nil
        timer.invalidate()
        manager?.stopUpdatingLocation()
        pauseBtn.setImage(UIImage(named: "resumeButton"), for: .normal)
    }
  
    
    func startTimer() {
        durationLbl.text = counter.formatTimeDuration()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
        counter += 1
        durationLbl.text = counter.formatTimeDuration()
    }
    
    @IBAction func pauseBtnClick(_ sender: Any) {
        if timer.isValid {
            pauseRun()
        } else {
            initiateRun()
        }
    }
    
    func setupGesturesForSlider() {
        let swipe = UIPanGestureRecognizer(target: self, action: #selector(self.onSwipeAction(sender:)))
        sliderImgView.addGestureRecognizer(swipe)
        sliderImgView.isUserInteractionEnabled = true
        swipe.delegate = self as? UIGestureRecognizerDelegate
    }
    
    func calculatePace(time seconds: Int, perKm km: Double) -> String {
        pace = Int(Double(seconds) / km)
        return pace.formatTimeDuration()
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
                    
                    self.endRun()
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


extension CurrentRunViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationPermissions()
        } else {
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil {
            startLocation = locations.first
        } else if let location = locations.last {
            runDistance += lastLocation.distance(from: location)
            
            let newLocation = Location(lat: Double(lastLocation.coordinate.latitude), long: Double(lastLocation.coordinate.longitude))
            
            coordLocations.insert(newLocation, at: 0)
            
            distanceLbl.text = "\(runDistance.metersToKilometers(places: 2))"
            if counter > 0 && runDistance > 0 {
                paceLbl.text = calculatePace(time: counter, perKm: runDistance.metersToKilometers(places: 2))
            }
        }
        
        lastLocation = locations.last;
    }
}

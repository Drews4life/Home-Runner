//
//  LocationViewController.swift
//  Home-Runner
//
//  Created by Andrii Zakharenkov on 2/15/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit
import MapKit


class LocationViewController: UIViewController, MKMapViewDelegate {
    
    var manager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        manager = CLLocationManager()
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.activityType = .fitness
    }
    
    func checkLocationPermissions() {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            manager?.requestWhenInUseAuthorization()
        }
    }

}

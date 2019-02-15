//
//  FirstViewController.swift
//  Home-Runner
//
//  Created by Andrii Zakharenkov on 2/14/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit
import MapKit

class StartRunViewController: LocationViewController {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        checkLocationPermissions()
        
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        manager?.delegate = self
        manager?.startUpdatingLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        manager?.stopUpdatingLocation()
    }
    
    @IBAction func centerLocationClick(_ sender: Any) {
        
    }
    
    @IBAction func startRunningClick(_ sender: Any) {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            return
        } else {
            performSegue(withIdentifier: "toRunVC", sender: self)
        }
    }
    
}

extension StartRunViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
        } else {
            return
        }
    }
}

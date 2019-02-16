//
//  FirstViewController.swift
//  Home-Runner
//
//  Created by Andrii Zakharenkov on 2/14/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class StartRunViewController: LocationViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var avgPaceLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var prevRunCloseBtn: UIButton!
    @IBOutlet weak var prevRunBG: UIView!
    @IBOutlet weak var prevRunStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        checkLocationPermissions()
        centerMapOnUserLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        mapView.delegate = self
        manager?.delegate = self
        manager?.startUpdatingLocation()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setupMapView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        manager?.stopUpdatingLocation()
    }
    
    
    func setupMapView() {
        if let overlay = addLastRunToMap() {
            if mapView.overlays.count > 0 {
                mapView.removeOverlays(mapView.overlays)
            }
            mapView.addOverlay(overlay)
            showPrevRunView()
        } else {
            hidePrevRunView()
            centerMapOnUserLocation()
        }
    }
    
    func addLastRunToMap() -> MKPolyline? {
        guard let lastRun = Run.retrieveAllRuns()?.first else { return nil }
        avgPaceLbl.text = lastRun.pace.formatTimeDuration()
        durationLbl.text = lastRun.duration.formatTimeDuration()
        distanceLbl.text = "\(lastRun.distance.metersToKilometers(places: 2)) km"
        
        var coordinates = [CLLocationCoordinate2D]()
        
        for location in lastRun.locations {
            coordinates.append(CLLocationCoordinate2D(latitude: location.lat, longitude: location.long))
        }
        
        mapView.userTrackingMode = .none
        mapView.setRegion(centerMapOnPolyline(locations: lastRun.locations), animated: true)
        
        return MKPolyline(coordinates: coordinates, count: lastRun.locations.count)
    }
    
    func hidePrevRunView() {
        prevRunBG.isHidden = true
        prevRunStack.isHidden = true
        prevRunCloseBtn.isHidden = true
    }
    
    func showPrevRunView() {
        prevRunBG.isHidden = false
        prevRunStack.isHidden = false
        prevRunCloseBtn.isHidden = false
    }
    
    @IBAction func closeOverlayClick(_ sender: Any) {
        hidePrevRunView()
        centerMapOnUserLocation()
    }
    
    @IBAction func centerLocationClick(_ sender: Any) {
        centerMapOnUserLocation()
    }
    
    func centerMapOnUserLocation() {
        mapView.userTrackingMode = .follow
        let coordinateRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func centerMapOnPolyline(locations: List<Location>) -> MKCoordinateRegion {
        guard let initialLocation = locations.first else { return MKCoordinateRegion() }
        var minLat = initialLocation.lat
        var minLong = initialLocation.long
        var maxLat = minLat
        var maxLong = minLong
        
        for location in locations {
            minLat = min(minLat, location.lat)
            minLong = min(minLong, location.long)
            
            maxLat = max(maxLat, location.lat)
            maxLong = max(maxLong, location.long)
        }
        
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLong + maxLong) / 2), span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3 , longitudeDelta: (maxLong - minLong) * 1.3))
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
            //mapView.userTrackingMode = .follow
        } else {
            return
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        renderer.lineWidth = 3
        
        return renderer
    }
}

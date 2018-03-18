//
//  CLServices.swift
//  Local notification
//
//  Created by Tom on 17/03/2018.
//  Copyright © 2018 Tom. All rights reserved.
//

import Foundation
import CoreLocation

class CLServices: NSObject {
    
    private override init() {}
    
    static let shared = CLServices()
    
    let locationManager = CLLocationManager()
    var shouldcheckLocation = true
    
    func authorize() {
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        
    }
    func updateLocation() {
        shouldcheckLocation = true
        locationManager.startUpdatingLocation()
    }
}
extension CLServices: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("got location")
        guard let currnetLocatrion = locations.first else {return}
        shouldcheckLocation = false
        let region = CLCircularRegion(center: currnetLocatrion.coordinate, radius: 20, identifier: "startPosition")
        manager.startMonitoring(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("did enter region")
        NotificationCenter.default.post(name: NSNotification.Name("internalNotification.enterRegion"), object: nil)
    }
    
}

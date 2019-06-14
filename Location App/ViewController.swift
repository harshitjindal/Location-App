//
//  ViewController.swift
//  Location App
//
//  Created by Harshit Jindal on 14/06/19.
//  Copyright © 2019 Harshit Jindal. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{

    let locationManager = CLLocationManager()
    
    var lastLocationUpdate:Date?
    var lastLocation:CLLocation?
    var consecutiveLocationDistance:Double?
    var stays = [CLLocationCoordinate2D]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            let locationTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (Timer) in
                self.locationManager.startUpdatingLocation()
                print("Timer Fired!")
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first {
            if lastLocation != nil {
                consecutiveLocationDistance = currentLocation.distance(from: lastLocation!)
                if consecutiveLocationDistance! <= 10 {
                    stays.append(currentLocation.coordinate)
                    print("-=-=-==-=--",stays)
                    print("Stay Detected at \(currentLocation.coordinate)")
                    print("Number of Stays: \(stays.count ?? 0)")
                } else {
                    print("Target is moving!")
                }
            }
            lastLocationUpdate = Date()
            locationManager.stopUpdatingLocation()
            lastLocation = currentLocation
            
            print(currentLocation.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.denied  {
            showLocationDisabledPopup()
        }
    }
    
    func showLocationDisabledPopup() {
        let alert = UIAlertController(title: "Location Use Disabled", message: "Please Allow Location Use", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alert.addAction(openAction)
        
        present(alert, animated: true, completion: nil)
    }


}


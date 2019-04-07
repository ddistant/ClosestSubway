//
//  RootViewModel.swift
//  ClosestSubway
//
//  Created by Daniel Distant on 4/7/19.
//  Copyright © 2019 Daniel Distant. All rights reserved.
//

import CoreLocation
import MapKit

struct SubwayStation {
    let name: String
}

class RootViewModel: NSObject {
    
    // MARK: - properties
    private (set) var subwayStations = [SubwayStation]()
    private (set) var currentLocation: CLLocation?
    
    private var searchCompleter: MKLocalSearchCompleter {
        let completer = MKLocalSearchCompleter()
        completer.delegate = self
        
        return completer
    }
    
    private var locationManager: CLLocationManager {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
        }
        
        return manager
    }
    
    // MARK: - initializer
    override init() {
        super.init()
        
        getClosestSubwayStations()
    }
    
    // MARK: - public methods
    func getCurrentLocation() {
        
    }
    
    func getClosestSubwayStations() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        searchCompleter.queryFragment = "subway"
        
        defer {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        let mockStation1 = SubwayStation(name: "station1")
        let mockStation2 = SubwayStation(name: "station2")
        let mockStation3 = SubwayStation(name: "station3")
        
        subwayStations = [mockStation1, mockStation2, mockStation3]
    }
}

// MARK: - MKLocalSearchCompleterDelegate
extension RootViewModel: MKLocalSearchCompleterDelegate {
    
}

// MARK: - CLLocationManagerDelegate
extension RootViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }
}

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
    let address: String
}

class RootViewModel: NSObject {
    // MARK: - enums
    private enum Constants {
        static let query = "subway"
    }
    
    // MARK: - properties
    private (set) var subwayStations = [SubwayStation]()
    private (set) var currentLocation: CLLocation?
    private (set) var locationServicesEnabled = false {
        didSet {
            if locationServicesEnabled == true && CLLocationManager.locationServicesEnabled() {
                locationManager?.startUpdatingLocation()
            }
        }
    }
    
    private var locationManager: CLLocationManager?
    
    // MARK: - initializer
    override init() {
        super.init()
        
        setupLocationManager()
        startSubwaySearch()
    }
    
    // MARK: - public methods    
    func startSubwaySearch() {
        // clear current subways
        subwayStations = []
        
        // create request
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = Constants.query
        request.region = makeRegion(from: currentLocation ?? CLLocation())
        
        // create completion handler
        let completionHandler: MKLocalSearch.CompletionHandler = { [weak self] (response, error) in
            guard error == nil else {
                // implement real error handling
                print("✂️ search error:", error?.localizedDescription ?? "error description failed")
                return
            }
            
           self?.createSubwayStations(from: response)
        }
        
        // create and start search
        let localSearch = MKLocalSearch(request: request)
        localSearch.start(completionHandler: completionHandler)
    }
    
    // MARK: - private methods
    private func setupLocationManager() {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
        }
        
        locationManager = manager
    }
    
    private func createSubwayStations(from response: MKLocalSearch.Response?) {
        guard let response = response else {
            print("🥶 no response present")
            return
        }
        
        print("💀 response:", response)
        
        response.mapItems.forEach {
            let station = SubwayStation(name: $0.name ?? "no name found",
                                        address: ($0.placemark.thoroughfare ?? "" ) + ($0.placemark.subThoroughfare ?? ""))
            
            subwayStations.append(station)
        }
    }
    
    private func makeRegion(from location: CLLocation) -> MKCoordinateRegion {
        let span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        
        return region
    }
}



// MARK: - CLLocationManagerDelegate
extension RootViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            locationServicesEnabled = false
        default:
            locationServicesEnabled = true
        }
        
        print("🧠 authorization status:", status.rawValue)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }
}

class SettingsManager {
    // MARK: - enums
    enum SettingsBundleKeys {
        static let location = "location_enabled_preference"
    }
    
    class func checkAndExecuteSettings() {
        if UserDefaults.standard.bool(forKey: SettingsBundleKeys.location) {
           // WIP, do something here
        }
    }
}

//
//  CLService.swift
//  RecordatorioEfc
//
//  Created by eduardo fulgencio on 10/01/2020.
//

import Foundation
import CoreLocation

enum SeleccionPosicion {
    case aviso
    case hogar
}

protocol ObtenerPosicion: class {
    func posicionActual(location: CLLocation)
}

class CLService: NSObject {
    
    let locationManager = CLLocationManager()
    weak var delegate: ObtenerPosicion?
    var seleccionPosicion = SeleccionPosicion.aviso
    var shouldSetRegion = true
    
    private override init() {}
    
    static let shared = CLService()
    
    func authorize() {
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    func updateLocation() {
        shouldSetRegion = true
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status:CLAuthorizationStatus) {
           if status == .authorizedWhenInUse {
               startLocationTracking()
           }
    }
    
    func startLocationTracking() {
           if CLLocationManager.locationServicesEnabled() {
               locationManager.startUpdatingLocation()
                // hacia donde mira el usuario
                if CLLocationManager.headingAvailable() {
                     locationManager.startUpdatingHeading()
                }
           }
    }
}

extension CLService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first, shouldSetRegion else { return }
        self.delegate?.posicionActual(location: locations.first!)

        if seleccionPosicion == SeleccionPosicion.aviso {
            let region = CLCircularRegion(center: currentLocation.coordinate, radius: 5, identifier: "startPosition")
            if !locationManager.monitoredRegions.contains(region) {
                manager.startMonitoring(for: region)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        NotificationCenter.default.post(name: NSNotification.Name("internalNotification.enteredRegion"),
                                        object: nil)

        print("\(region.identifier)")
       // manager.stopMonitoring(for: region)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
           print("\(newHeading.trueHeading)")
    }
    
}

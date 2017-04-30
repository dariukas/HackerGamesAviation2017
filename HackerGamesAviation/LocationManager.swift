//
//  Location.swift
//  HackerGamesAviation
//
//  Created by Darius Miliauskas on 29/04/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//
//http://dev.iachieved.it/iachievedit/corelocation-on-ios-8-with-swift/


//http://rshankar.com/internationalization-and-localization-of-apps-in-xcode-6-and-swift/
//https://www.iphonelife.com/blog/31369/swift-101-demystifying-swifts-initializers-part-2
//http://devmonologue.com/ios/swift/swift-initializers-designated-convenience/
//private, internal, framework, designable inpectable
//mapkit, coredata, VR

//https://spin.atomicobject.com/2014/10/25/ios-unwind-segues/

import UIKit
import CoreLocation
import MapKit

class LocationManager: NSObject, CLLocationManagerDelegate, MKMapViewDelegate {

    var locationManager:CLLocationManager = CLLocationManager()
    var locations: [CLLocation] = []
    var mapView: MapView?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.distanceFilter  = 1000 // Must move at least 1km
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer // Accurate within a kilometer
    }
    
    func adding() {
        if let theMapView = self.mapView {
            theMapView.delegate = self
        }
    }

    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        
        print("didChangeAuthorizationStatus")
        switch status {
        case .notDetermined:
            print(".NotDetermined")
            break
        case .authorized:
            print(".Authorized")
            self.locationManager.startUpdatingLocation()
            break
        case .denied:
            print(".Denied")
            break
            
        default:
            print("Unhandled authorization status")
            break
        }
    }
    
    func stop() {
        self.locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
        if let lastLocation = locations.last {
            print("didUpdateLocations:  \(lastLocation.coordinate.latitude), \(lastLocation.coordinate.longitude)")
            self.locations.append(lastLocation)
            
            let location = CameraInfo(
                coordinates: lastLocation.coordinate,
                heading: 80.00)
            
            if let theMapView = self.mapView {
                theMapView.setRegionForLocation(location: location.location, spanRadius: 150.0, animated: true)
                theMapView.setCamera(locationCoordinate: location.location)
//                theMapView.setCamera(info: location)
                polyline(mapView: theMapView)
            }
        }
    }
    
    func polyline(mapView: MapView) {
        if (self.locations.count > 1){
            let sourceIndex = self.locations.count - 1
            let destinationIndex = self.locations.count - 2
            
            let c1 = self.locations[sourceIndex].coordinate
            let c2 = self.locations[destinationIndex].coordinate
            var a = [c1, c2]
            let polyline = MKPolyline(coordinates: &a, count: a.count)
            mapView.add(polyline)
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error){
        print(error)
    }
    
    // MARK: MKMapViewDelegate
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        var view : MKPinAnnotationView
//        view.tintColor = UIColor.purple
//        return view
//    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        
        
//        self.mapView.setRegionForLocation(location: location.location, spanRadius: 150.0, animated: true)
//        //theMapView.setCamera(info: location)
//        self.mapView.setCamera(locationCoordinate: location.location)
    }
    
}

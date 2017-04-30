//
//  CameraMap.swift
//  HackerGamesAviation
//
//  Created by Darius Miliauskas on 29/04/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapView: MKMapView, MKMapViewDelegate {
    
//    var camera1 = MKMapCamera()
//    
//    
//   convenience init() {
//       self.init()
//    }
    //
    //    required init?(coder decoder: NSCoder) {
    //        super.init(coder: decoder)
    //        //fatalError("init(coder:) has not been implemented")
    //    }

    //MARK: Instance methods
    func setRegionForLocation(
        location:CLLocationCoordinate2D,
        spanRadius:Double,
        animated:Bool)
    {
        let span = 2.0 * spanRadius
        let region = MKCoordinateRegionMakeWithDistance(location, span, span)
        self.setRegion(region, animated: animated)
    }
    
    //    func setCamera2() {
//        let camera = MKMapCamera()
//        camera.centerCoordinate = self.centerCoordinate
//        camera.pitch = 80.0
//        camera.altitude = 100.0
//        camera.heading = 45.0
//        self.setCamera(camera, animated: true)
//    }
    
    func setCamera(locationCoordinate: CLLocationCoordinate2D) {
        var eyeCoordinate = locationCoordinate
        eyeCoordinate.latitude += 0.005
        eyeCoordinate.longitude += 0.005
        let camera = MKMapCamera(lookingAtCenter: locationCoordinate, fromEyeCoordinate: eyeCoordinate, eyeAltitude: 50)
        self.setCamera(camera, animated: true)
        //self.camera = camera
    }
    
    func setCamera(info: CameraInfo) {
        let camera = MKMapCamera(lookingAtCenter: info.location, fromDistance: 40, pitch: 60, heading: info.heading)
        self.setCamera(camera, animated: true)
    }
    
    // MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }
}

//MARK: Location constants
struct CameraInfo{
    var location = CLLocationCoordinate2D()
    var heading = CLLocationDirection()
    init(
//        latitude:CLLocationDegrees,
//        longitude:CLLocationDegrees,
        coordinates:CLLocationCoordinate2D,
        heading:CLLocationDirection
        ){
//        self.location = CLLocationCoordinate2D(
//            latitude: latitude,
//            longitude: longitude)
        self.location = coordinates
        self.heading = heading
    }
}

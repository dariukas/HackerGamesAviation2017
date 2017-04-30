//
//  ViewController.swift
//  HackerGamesAviation
//
//  Created by Darius Miliauskas on 29/04/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    //@IBOutlet weak var locationMap: MKMapView!
    
    @IBOutlet weak var mapView: MapView!
    let location = LocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UIView.animateWithDuration(5.0, animations: { () -> Void in
//            self.mapView.setCamera(camera, animated: true);
//        }, completion: { (finished) -> Void in
//        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initLoc()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startScreening(_ sender: Any) {
        run()
    }
    
    func run() {
        mapView.userTrackingMode = .follow
        location.mapView = mapView
        location.adding()
    }
    
    func initLoc() {
        let hudsonLocation = CameraInfo(
            coordinates: CLLocationCoordinate2D(latitude: 42.4094223, longitude: -81.776519),
            heading: 80.00)
        
        if let theMapView = self.mapView {
            theMapView.setRegionForLocation(location: hudsonLocation.location, spanRadius: 100.0, animated: true)
            theMapView.setCamera(locationCoordinate: hudsonLocation.location)
            let places = FunFactPlacesLocationList().funFactPlaces
            theMapView.addAnnotations(places)
        }
    }
    
    class FunFactPlacesLocation: NSObject, MKAnnotation{
        var identifier = "pizza location"
        var title: String?
        var coordinate: CLLocationCoordinate2D
        init(name:String,lat:CLLocationDegrees,long:CLLocationDegrees){
            title = name
            coordinate = CLLocationCoordinate2DMake(lat, long)
        }
    }
    
    class FunFactPlacesLocationList: NSObject {
        var funFactPlaces = [FunFactPlacesLocation]()
        override init(){
            funFactPlaces += [FunFactPlacesLocation(name:"Hacker Games Pizza",lat:42.409423,long:-81.776520)]
            funFactPlaces += [FunFactPlacesLocation(name:"Miracle At Hudson",lat:42.409423,long: -81.776519)]
        }
    }
}


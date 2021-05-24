//
//  MapViewController.swift
//  IOSProgramming
//
//  Created by KPUGAME on 2021/05/23.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    var posts = NSMutableArray()
    
    var initLat: Double = 0.0
    var initLon: Double = 0.0
    
    let regionRadius: CLLocationDistance = 5000
    
    func centerMapOnLocation(location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)

        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    var chargingStations : [ElectricCar] = []
    
    func loadInitialData()
    {
        for post in posts
        {
            let csNm = (post as AnyObject).value(forKey: "csNm") as! NSString as String
            let addr = (post as AnyObject).value(forKey: "addr") as! NSString as String
            let XPos = (post as AnyObject).value(forKey: "longi") as! NSString as String
            let YPos = (post as AnyObject).value(forKey: "lat") as! NSString as String
            let lat = (YPos as NSString).doubleValue
            let lon = (XPos as NSString).doubleValue
            let chargingStation = ElectricCar(title: csNm, locationName: addr, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
            chargingStations.append(chargingStation)
            initLat = lat
            initLon = lon
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        let location = view.annotation as! ElectricCar
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        guard let annotation = annotation as? ElectricCar else { return nil }
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        {
            dequeuedView.annotation = annotation
            view = dequeuedView
        }
        else
        {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loadInitialData()
        let initialLocation = CLLocation(latitude: initLat, longitude: initLon)
        centerMapOnLocation(location: initialLocation)
        mapView.delegate = self
        //loadInitialData()
        mapView.addAnnotations(chargingStations)
    }
    


}

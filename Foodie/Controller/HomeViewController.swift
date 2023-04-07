//
//  HomeViewController.swift
//  Foodie
//
//  Created by Luis Calvillo on 4/5/23.
//

import UIKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController {
    
    var locationManager: CLLocationManager?
    
    var currentLocation = [0.0, 0.0]
    var latitude = 0.0
    var longitude = 0.0
    
    var businesses: [Business] = []
    
    var customPointAnnotation: CustomPointAnnotation!
    var selectedAnnotation: CustomPointAnnotation?
    
    let mapView = MKMapView()
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let mapWidth = view.frame.size.width
        let mapHeight = view.frame.size.height
        
        mapView.frame = CGRect(x: 0, y: 0, width: mapWidth, height: mapHeight)
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        mapView.center = view.center
        
        view.addSubview(mapView)
    }
    
    func addBusinessesToMap() {
        for business in businessList {
            customPointAnnotation = CustomPointAnnotation()
            customPointAnnotation.title = business.name
            customPointAnnotation.address = business.address
            customPointAnnotation.imageUrl = business.imageURL
            customPointAnnotation.latitude = business.latitude
            customPointAnnotation.longitude = business.longitude
            customPointAnnotation.distance = business.distance
            customPointAnnotation.isClosed = business.isClosed
            
            if let lat = business.coordinates!["latitude"], let lon = business.coordinates!["longitude"] {
                customPointAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                mapView.addAnnotation(customPointAnnotation)
            }
        }
    }
}


// MARK: - Extensions

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            
            locationManager?.stopUpdatingLocation()
            
            if let lat = locationManager?.location?.coordinate.latitude, let lon = locationManager?.location?.coordinate.longitude {
                latitude = lat
                longitude = lon
                
                locationManager?.stopUpdatingLocation()
                
                businessList = []
                
                self.retrieveBusinesses(latitude: self.latitude, longitude: self.longitude, category: "food", limit: 50, sortBy: "distance", locale: "en_US") { (response, error) in
                    
                    if let response = response {
                        businessList = response
                        DispatchQueue.main.async { [self] in
                            self.addBusinessesToMap()
                        }
                    }
                }
            }
        } else {
            
        }
    }
}

extension HomeViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation as? CustomPointAnnotation else { return }
        
        self.selectedAnnotation = annotation
        
   
        if view .isKind(of: MKUserLocation.self) {
            
        } else {
            let businessDistanceInMiles = selectedAnnotation?.distance.getMiles()
            let roundedDistanceInMiles = String(format: "%.2f", ceil(businessDistanceInMiles! * 100) / 100)
            let businessImageUrl = selectedAnnotation?.imageUrl ?? ""
        }
    }
}


class CustomPointAnnotation: MKPointAnnotation {
    var name: String!
    var address: String!
    var coordinates: [String : Double]!
    var imageUrl: String!
    var latitude: Double!
    var longitude: Double!
    var distance: Double!
    var isClosed: Bool!
    var hours: [String : Any]!
}

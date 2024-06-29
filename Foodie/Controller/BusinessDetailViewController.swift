//
//  BusinessDetailViewController.swift
//  Foodie
//
//  Created by Luis Calvillo on 4/9/23.
//

import UIKit
import SDWebImage
import MapKit

class BusinessDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var name = ""
    var address = ""
    var distance = 0.0
    var latitude = 0.0
    var longitude = 0.0
    var imageUrl = ""
    var businessRating = 0.0
    var currentLocation = [0.0, 0.0]
    
    var businessImageView = UIImageView()
    
    var businessNameLabel = UILabel()
    var addressLabel = UILabel()
    var distanceLabel = UILabel()
    var ratingLabel = UILabel()
  
    var businessInformationStackView = UIStackView()
    var background = UIView()
    var directionsButton = UIButton()
    let mapView = MKMapView()
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBackgroundView()
        createBusinessImageView()
        createBusinessInformationView()
        createMapView()
        showMapLocationFromCoordinates()
        createDirectionsButton()
    }
    
    func createMapView() {
        let mapWidth = view.frame.size.width - 32
        let mapHeight: CGFloat = 150
        
        mapView.frame = CGRect(x: 16, y: self.view.frame.maxY - mapHeight - (mapHeight / 2), width: mapWidth, height: mapHeight)
        mapView.layer.cornerRadius = 16
        self.view.addSubview(mapView)
    }
    
    func showMapLocationFromCoordinates() {
        
        var region = MKCoordinateRegion()
        
        region.center.latitude = latitude
        region.center.longitude = longitude
        
        region.span.latitudeDelta = 0.001
        region.span.longitudeDelta = 0.001
        
        self.mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
        
        mapView.isPitchEnabled = false
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.isRotateEnabled = false
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate.latitude = latitude
        annotation.coordinate.longitude = longitude
        
        self.mapView.addAnnotation(annotation)
    }
    
    func createBackgroundView() {
        background = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        background.backgroundColor = .white
        self.view.addSubview(background)
    }
    
    func createBusinessImageView() {
        businessImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width))
        businessImageView.contentMode = .scaleAspectFill
        businessImageView.clipsToBounds = true
        
        self.background.addSubview(businessImageView)
        
        let imageView: UIImageView = self.businessImageView
        imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: nil)
    }
    
    func createBusinessInformationView() {
        
        // Business Name
        businessNameLabel.text = name
        businessNameLabel.textColor = .black
        businessNameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        // Rating
        ratingLabel.text = "\(businessRating)"
        ratingLabel.textColor = .black
        ratingLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        // Address
        addressLabel.text = address
        addressLabel.textColor = .black
        addressLabel.font = UIFont.systemFont(ofSize: 20)
        
        // Distance
        let businessDistanceInMiles = distance.getMiles()
        let roundedDistanceInMiles = String(format: "%.2f", ceil(businessDistanceInMiles * 100) / 100)
        
        distanceLabel.text = roundedDistanceInMiles + " mi"
        distanceLabel.textColor = .black
        distanceLabel.font = UIFont.systemFont(ofSize: 16)
        
        // Information Stack View
        businessInformationStackView = UIStackView(frame: CGRect(x: 16, y: self.view.frame.size.width, width: self.view.frame.size.width, height: 100))
        self.background.addSubview(businessInformationStackView)
        
        businessInformationStackView.axis = .vertical
        businessInformationStackView.distribution = .fillEqually
        
        businessInformationStackView.addArrangedSubview(businessNameLabel)
        businessInformationStackView.addArrangedSubview(ratingLabel)
        businessInformationStackView.addArrangedSubview(addressLabel)
        businessInformationStackView.addArrangedSubview(distanceLabel)
        
        print("Rating: \(businessRating)")
    }
    
    func createDirectionsButton() {
        
        directionsButton = UIButton(frame: CGRect(x: 16, y: mapView.frame.origin.y - 100, width: self.view.frame.size.width - 32, height: 60))
        directionsButton.setTitle("Directions", for: .normal)
        directionsButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        directionsButton.backgroundColor = UIColor.systemBlue
        directionsButton.layer.cornerRadius = 16
        
        self.background.addSubview(directionsButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToAppleMaps(sender:)))
        directionsButton.addGestureRecognizer(tapGesture)
    }
    
    
    // MARK: - Navigation
    
    @objc
    func goToAppleMaps(sender: UITapGestureRecognizer) {
        
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)))
        
        destination.name = name
        
        let yourLocation = CLLocation(latitude: currentLocation[0], longitude: currentLocation[1])
        let businessLocation = CLLocation(latitude: latitude, longitude: longitude)
                
        MKMapItem.openMaps(with: [destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}

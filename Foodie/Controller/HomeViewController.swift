//
//  HomeViewController.swift
//  Foodie
//
//  Created by Luis Calvillo on 4/5/23.
//

import UIKit
import MapKit
import CoreLocation
import SDWebImage

class HomeViewController: UIViewController {
    
    
    // MARK: - Properties
    
    var locationManager: CLLocationManager?
    
    var currentLocation = [0.0, 0.0]
    var latitude = 0.0
    var longitude = 0.0
    
    var businesses: [Business] = []
    
    var customPointAnnotation: CustomPointAnnotation!
    var selectedAnnotation: CustomPointAnnotation?
    
    let mapView = MKMapView()
    
    let businessPopUpStackView = UIStackView()
    let businessStackView = UIStackView()
    let businessImageView = UIImageView()
    let businessNameLabel = UILabel()
    let addressLabel = UILabel()
    let distanceLabel = UILabel()
    
    var isPopUpViewVisible = false
    
    var popUpView = UIView()
    
    let margin: CGFloat = 16
    let popUpViewHeight: CGFloat = 150
    
    
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
        
        createBusinessPopUpView()
        hidePopUpView()
        
        let popUpViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePopUpViewScreenTap(sender:)))
        popUpView.addGestureRecognizer(popUpViewTapGesture)
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
    
    func createBusinessPopUpView() {
        
        let width = view.self.frame.width - 32
        
        let originY: CGFloat = view.frame.height - popUpViewHeight - (margin * 2)
        
        popUpView = UIView(frame: CGRect(x: margin, y: originY, width: width, height: popUpViewHeight))
        popUpView.layer.cornerRadius = 32
        popUpView.clipsToBounds = true
        popUpView.backgroundColor = .white
        self.view.addSubview(popUpView)
        
        businessImageView.contentMode = .scaleAspectFill
        businessImageView.frame.size.width = 50
        
        businessPopUpStackView.axis = .horizontal
        businessPopUpStackView.alignment = .leading
        businessPopUpStackView.distribution = .equalSpacing
        
        businessStackView.axis = .vertical
        businessStackView.alignment = .leading
        businessStackView.distribution = .fillEqually
        
        businessNameLabel.text = ""
        addressLabel.text = ""
        distanceLabel.text = ""
        
        businessNameLabel.textColor = .black
        addressLabel.textColor = .black
        distanceLabel.textColor = .black
        
        businessStackView.addArrangedSubview(businessNameLabel)
        businessStackView.addArrangedSubview(addressLabel)
        businessStackView.addArrangedSubview(distanceLabel)
        
        businessPopUpStackView.addArrangedSubview(businessImageView)
        businessPopUpStackView.addArrangedSubview(businessStackView)
        popUpView.addSubview(businessPopUpStackView)
        
        businessPopUpStackView.distribution = .fillEqually
        businessPopUpStackView.spacing = 16
        businessPopUpStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            businessPopUpStackView.topAnchor.constraint(equalTo: popUpView.topAnchor),
            businessPopUpStackView.leadingAnchor.constraint(equalTo: popUpView.leadingAnchor),
            businessPopUpStackView.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor),
            businessPopUpStackView.bottomAnchor.constraint(equalTo: popUpView.bottomAnchor)
        ])
    }
    
    func showPopUpView() {
        
        isPopUpViewVisible = true
        
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 2.0, options: .curveEaseIn, animations: {
            self.popUpView.frame.origin.y = self.view.frame.height - self.popUpViewHeight - (self.margin * 2)
        }, completion: nil)
    }
    
    func hidePopUpView() {
        
        isPopUpViewVisible = false
        
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 2.0, options: .curveEaseIn, animations: {
            self.popUpView.frame.origin.y = self.view.frame.height + self.popUpViewHeight + self.margin
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func handlePopUpViewScreenTap(sender: UITapGestureRecognizer) {
        goToBusinessDetailVC()
    }
    
    
    // MARK: - Navigation
    
    func goToBusinessDetailVC() {
        
        let businessDetailVC = BusinessDetailViewController()
        let navVC = UINavigationController(rootViewController: businessDetailVC)
        
        if let businessName = selectedAnnotation?.title {
            businessDetailVC.name = businessName
        }
        
        if let businessAddress = selectedAnnotation?.address {
            businessDetailVC.address = businessAddress
        }
        
        if let businessDistance = selectedAnnotation?.distance {
            businessDetailVC.distance = businessDistance
        }
        if let businessLatitude = selectedAnnotation?.latitude {
            businessDetailVC.latitude = businessLatitude
        }
        
        if let businessLongitude = selectedAnnotation?.longitude {
            businessDetailVC.longitude = businessLongitude
        }
        
        if let businessImageURL = selectedAnnotation?.imageUrl {
            businessDetailVC.imageUrl = businessImageURL
        }
        
        self.present(navVC, animated: true)
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
                
                self.retrieveBusinesses(latitude: self.latitude, longitude: self.longitude, category: "food", limit: 10, sortBy: "distance", locale: "en_US") { (response, error) in
                    
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
        
        if isPopUpViewVisible == false {
            
            showPopUpView()
            
            if view .isKind(of: MKUserLocation.self) {
                
            } else {
                businessNameLabel.text = selectedAnnotation?.title
                addressLabel.text = selectedAnnotation?.address
                
                let businessDistanceInMiles = selectedAnnotation?.distance.getMiles()
                let roundedDistanceInMiles = String(format: "%.2f", ceil(businessDistanceInMiles! * 100) / 100)
                
                distanceLabel.text = roundedDistanceInMiles + " mi"
                
                let businessImageUrl = selectedAnnotation?.imageUrl ?? ""
                let imageView: UIImageView = self.businessImageView
                imageView.sd_setImage(with: URL(string: businessImageUrl), placeholderImage: nil)
            }
        } else {
            hidePopUpView()
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

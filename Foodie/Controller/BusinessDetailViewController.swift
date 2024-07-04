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
    var ratingLabelText = ""
    var displayPhone = ""
    var phone = ""
    
    var businessImageView = UIImageView()
    
    var businessNameLabel = UILabel()
    var addressLabel = UILabel()
    var distanceLabel = UILabel()
    var ratingLabel = UILabel()
    var displayPhoneLabel = UILabel()
  
    var businessInformationStackView = UIStackView()
    var background = UIView()
    var directionsButton = UIButton()
    var phoneButton = UIButton()
    var websiteButton = UIButton()
    var buttonsStackView = UIStackView()
    let mapView = MKMapView()
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBackgroundView()
        createBusinessImageView()
        createBusinessInformationView()
        createMapView()
        showMapLocationFromCoordinates()
        createButtonsStackView()
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
        ratingLabel.text = createStarRatings(rating: businessRating)
        ratingLabel.textColor = .black
        ratingLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        // Address
        addressLabel.text = address
        addressLabel.textColor = .black
        addressLabel.font = UIFont.systemFont(ofSize: 20)
        
        // Phone
        displayPhoneLabel.text = displayPhone
        displayPhoneLabel.textColor = .black
        displayPhoneLabel.font = UIFont.systemFont(ofSize: 20)
        
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
        businessInformationStackView.distribution = .equalSpacing
        
        businessInformationStackView.addArrangedSubview(businessNameLabel)
        businessInformationStackView.addArrangedSubview(ratingLabel)
        businessInformationStackView.addArrangedSubview(addressLabel)
        businessInformationStackView.addArrangedSubview(displayPhoneLabel)
        businessInformationStackView.addArrangedSubview(distanceLabel)  
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
    
    
    func createStarRatings(rating: Double?) -> String {
        switch rating {
        case 1.0:
            ratingLabelText = "⭐️"
        case 1.5:
            ratingLabelText = "⭐️✨"
        case 2.0:
            ratingLabelText = "⭐️⭐️"
        case 2.5:
            ratingLabelText = "⭐️⭐️✨"
        case 3.0:
            ratingLabelText = "⭐️⭐️⭐️"
        case 3.5:
            ratingLabelText = "⭐️⭐️⭐️✨"
        case 4.0:
            ratingLabelText = "⭐️⭐️⭐️⭐️"
        case 4.5:
            ratingLabelText = "⭐️⭐️⭐️⭐️✨"
        case 5.0:
            ratingLabelText = "⭐️⭐️⭐️⭐️⭐️"
        default:
            ratingLabelText = "⭐️⭐️⭐️⭐️⭐️"
        }
        
        return ratingLabelText
    }
    
    func createButtonsStackView() {
        background.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(phoneButton)
        buttonsStackView.addArrangedSubview(websiteButton)
        buttonsStackView.addArrangedSubview(directionsButton)
        
        buttonsStackView.spacing = 16
        
        buttonsStackView.distribution = .fillEqually
                
        phoneButton.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        phoneButton.backgroundColor = .blue
        phoneButton.setImage(UIImage(systemName: "phone"), for: .normal)
        phoneButton.layer.cornerRadius = 8
        phoneButton.tintColor = .white

        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: businessInformationStackView.bottomAnchor, constant: 16),
            buttonsStackView.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            buttonsStackView.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        websiteButton.backgroundColor = .green
        websiteButton.setImage(UIImage(systemName: "safari"), for: .normal)
        websiteButton.layer.cornerRadius = 8
        
        directionsButton.backgroundColor = .blue
        directionsButton.setImage(UIImage(systemName: "car"), for: .normal)
        directionsButton.layer.cornerRadius = 8
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

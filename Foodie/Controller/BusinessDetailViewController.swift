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
    var isClosed = false
    
    var currentLocation = [0.0, 0.0]
    
    var businessImageView = UIImageView()
    
    var businessNameLabel = UILabel()
    var addressLabel = UILabel()
    var distanceLabel = UILabel()
    
    var businessStackView = UIStackView()
    var background = UIView()
    var directionsButton = UIButton()
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBackgroundView()
        createBusinessImageView()
        createBusinessInformationView()
        createDirectionsButton()
    }
    
    func createBackgroundView() {
        background = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        background.backgroundColor = .white
        self.view.addSubview(background)
    }
    
    func createBusinessImageView() {
        businessImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width))
        
        self.background.addSubview(businessImageView)
        
        let imageView: UIImageView = self.businessImageView
        imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: nil)
    }
    
    func createBusinessInformationView() {
        businessNameLabel.text = name
        addressLabel.text = address
        
        let businessDistanceInMiles = distance.getMiles()
        let roundedDistanceInMiles = String(format: "%.2f", ceil(businessDistanceInMiles * 100) / 100)
        
        distanceLabel.text = roundedDistanceInMiles + " mi"
        
        businessNameLabel.textColor = .black
        addressLabel.textColor = .black
        distanceLabel.textColor = .black
        
        businessStackView = UIStackView(frame: CGRect(x: 16, y: self.view.frame.size.width + 16, width: self.view.frame.size.width, height: 150))
        self.background.addSubview(businessStackView)
        
        businessStackView.axis = .vertical
        businessStackView.distribution = .fillProportionally
        
        businessStackView.addArrangedSubview(businessNameLabel)
        businessStackView.addArrangedSubview(addressLabel)
        businessStackView.addArrangedSubview(distanceLabel)
    }
    
    func createDirectionsButton() {
        directionsButton = UIButton(frame: CGRect(x: 16, y: self.view.frame.size.height - 200, width: self.view.frame.size.width - 32, height: 100))
        directionsButton.setTitle("Directions", for: .normal)
        directionsButton.backgroundColor = UIColor.systemBlue
        directionsButton.layer.cornerRadius = 16
        
        self.background.addSubview(directionsButton)
        
        var tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToAppleMaps(sender:)))
        directionsButton.addGestureRecognizer(tapGesture)
    }
    
    
    // MARK: - Navigation
    
    @objc
    func goToAppleMaps(sender: UITapGestureRecognizer) {
        
        let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: currentLocation[0], longitude: currentLocation[1])))
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)))
        
        destination.name = name
        
        let yourLocation = CLLocation(latitude: currentLocation[0], longitude: currentLocation[1])
        let businessLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        let distance = businessLocation.distance(from: yourLocation)
        
        MKMapItem.openMaps(with: [destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}

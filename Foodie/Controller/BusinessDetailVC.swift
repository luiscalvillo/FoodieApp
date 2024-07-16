//
//  BusinessDetailVC.swift
//  Foodie
//
//  Created by Luis Calvillo on 4/9/23.
//

import UIKit
import MapKit

class BusinessDetailVC: UIViewController {
    
    // MARK: - Properties
    
    private var business: Business
    private var businessImageView = UIImageView()
    private  var ratingLabelText = ""
   
    private var businessNameLabel = UILabel()
    private var addressLabel = UILabel()
    private var distanceLabel = UILabel()
    private var ratingLabel = UILabel()
  
    private var businessInformationStackView = UIStackView()
    private var background = UIView()
    private var directionsButton = UIButton()
    private var phoneButton = UIButton()
    private var websiteButton = UIButton()
    private var buttonsStackView = UIStackView()
    private let mapView = MKMapView()
    
    
    // MARK: - Initialization
    
    init(business: Business) {
        self.business = business
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBackgroundView()
        createBusinessImageView()
        createBusinessInformationView()
        showMapLocationFromCoordinates()
        createButtonsStackView()
        createMapView()
    }
    
    
    // MARK: - Setup Methods
    
    func createMapView() {

        self.view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: background.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: background.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: 16),
        ])
    }
    
    func showMapLocationFromCoordinates() {
        
        var region = MKCoordinateRegion()
        
        region.center.latitude = business.latitude ?? 0.0
        region.center.longitude = business.longitude ?? 0.0
        
        region.span.latitudeDelta = 0.001
        region.span.longitudeDelta = 0.001
        
        self.mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
        
        mapView.isPitchEnabled = false
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.isRotateEnabled = false
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate.latitude = business.latitude ?? 0.0
        annotation.coordinate.longitude = business.longitude ?? 0.0
        
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
        imageView.sd_setImage(with: URL(string: business.imageURL ?? ""), placeholderImage: nil)
    }
    
    func createBusinessInformationView() {
        
        // Business Name
        businessNameLabel.text = business.name
        businessNameLabel.textColor = .black
        businessNameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        // Rating
        ratingLabel.text = createStarRatings(rating: business.rating, ratingLabelText: ratingLabelText)
        ratingLabel.textColor = .black
        ratingLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        // Address
        addressLabel.text = business.address
        addressLabel.textColor = .black
        addressLabel.font = UIFont.systemFont(ofSize: 20)
        
        // Distance
        let businessDistanceInMiles = business.distance?.getMiles() ?? 0.0
        let roundedDistanceInMiles = String(format: "%.2f", ceil(businessDistanceInMiles * 100) / 100)
        
        distanceLabel.text = roundedDistanceInMiles + " mi"
        distanceLabel.textColor = .black
        distanceLabel.font = UIFont.systemFont(ofSize: 16)
        
        // Information Stack View
        businessInformationStackView = UIStackView(frame: CGRect(x: 16, y: self.view.frame.size.width, width: self.view.frame.size.width, height: 150))
        self.background.addSubview(businessInformationStackView)
        
        businessInformationStackView.axis = .vertical
        businessInformationStackView.distribution = .equalSpacing
        
        businessInformationStackView.addArrangedSubview(businessNameLabel)
        businessInformationStackView.addArrangedSubview(ratingLabel)
        businessInformationStackView.addArrangedSubview(addressLabel)
        businessInformationStackView.addArrangedSubview(distanceLabel)  
    }
    
    func createButtonsStackView() {
        background.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(directionsButton)
        buttonsStackView.addArrangedSubview(phoneButton)
        buttonsStackView.addArrangedSubview(websiteButton)
      
        buttonsStackView.spacing = 16
        
        buttonsStackView.distribution = .fillEqually
                
        phoneButton.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        phoneButton.backgroundColor = .white
        phoneButton.setImage(UIImage(systemName: "phone"), for: .normal)
        phoneButton.layer.cornerRadius = 8
        phoneButton.layer.borderColor = UIColor.lightGray.cgColor
        phoneButton.layer.borderWidth = 2
        phoneButton.tintColor = .lightGray
        
        phoneButton.addTarget(self, action: #selector(phoneButtonTapped), for: .touchUpInside)

        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: businessInformationStackView.bottomAnchor, constant: 16),
            buttonsStackView.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            buttonsStackView.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        websiteButton.backgroundColor = .white
        websiteButton.setImage(UIImage(systemName: "safari"), for: .normal)
        websiteButton.layer.cornerRadius = 8
        websiteButton.layer.borderColor = UIColor.lightGray.cgColor
        websiteButton.layer.borderWidth = 2
        websiteButton.tintColor = .lightGray
        
        let websiteTapGesture = UITapGestureRecognizer(target: self, action: #selector(goToAppleMaps(sender:)))
        websiteButton.addGestureRecognizer(websiteTapGesture)
        
        directionsButton.backgroundColor = .white
        directionsButton.layer.borderColor = UIColor.lightGray.cgColor
        directionsButton.layer.borderWidth = 2
        directionsButton.setImage(UIImage(systemName: "car"), for: .normal)
        directionsButton.layer.cornerRadius = 8
        directionsButton.tintColor = .lightGray
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToAppleMaps(sender:)))
        directionsButton.addGestureRecognizer(tapGesture)
    }
    
    
    @objc
    func phoneButtonTapped() {
        makePhoneCall(phoneNumber: business.phone ?? "")
    }
    
    func makePhoneCall(phoneNumber: String) {
        if let phoneURL = NSURL(string: ("tel://" + (business.phone ?? ""))) {
            let alert = UIAlertController(title: ("Call " + (business.displayPhone ?? "") + "?"), message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action) in
                UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc
    func websiteButtonTapped() {
        if let url = URL(string: business.website ?? "") {
            open(url: url)
        } else {
            print("Invalid url")
        }
    }
    
    func open(url: URL) {
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                print("Open \(url): \(success)")
            })
        } else if UIApplication.shared.openURL(url) {
            print("Open \(url)")
        }
    }
    
    
    // MARK: - Navigation
    
    @objc
    func goToAppleMaps(sender: UITapGestureRecognizer) {
        
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: business.latitude ?? 0.0, longitude: business.longitude ?? 0.0)))
        
        destination.name = business.name

        MKMapItem.openMaps(with: [destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}

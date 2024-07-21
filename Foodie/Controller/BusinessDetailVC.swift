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
    
    var customPointAnnotation: CustomPointAnnotation!
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
        
        mapView.delegate = self
        
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
        
        customPointAnnotation = CustomPointAnnotation()
        
        customPointAnnotation.coordinate = CLLocationCoordinate2D(latitude: business.latitude ?? 0.0, longitude: business.longitude ?? 0.0)
        
        self.mapView.addAnnotation(customPointAnnotation)
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
        businessInformationStackView.distribution = .fillProportionally
        
        businessInformationStackView.addArrangedSubview(businessNameLabel)
        businessInformationStackView.addArrangedSubview(ratingLabel)
        businessInformationStackView.addArrangedSubview(addressLabel)
        businessInformationStackView.addArrangedSubview(distanceLabel)
    }
    
    func createButtonsStackView() {
        buttonsStackView = UIStackView(arrangedSubviews: [directionsButton, phoneButton, websiteButton])

        background.addSubview(buttonsStackView)

        buttonsStackView.spacing = 16
        buttonsStackView.distribution = .fillProportionally
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: businessInformationStackView.bottomAnchor, constant: 16),
            buttonsStackView.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            buttonsStackView.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        configureButton(button: directionsButton, imageName: "car", title: "Directions", isPrimary: true)

        configureButton(button: phoneButton, imageName: "phone", title: "Phone")
        configureButton(button: websiteButton, imageName: "safari", title: "Website")
        
        phoneButton.widthAnchor.constraint(equalTo: websiteButton.widthAnchor).isActive = true
        directionsButton.widthAnchor.constraint(equalTo: phoneButton.widthAnchor, multiplier: 2).isActive = true
    }
    
    @objc
    func directionsButtonTapped() {
        goToAppleMaps()
    }
    
    @objc
    func phoneButtonTapped() {
        makePhoneCall(phoneNumber: business.phone ?? "")
    }
    
    @objc
    func websiteButtonTapped() {
        if let url = URL(string: business.website ?? "") {
            open(url: url)
        } else {
            print("Invalid url")
        }
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
    
    func configureButton(button: UIButton, imageName: String, title: String, isPrimary: Bool = false, fontSize: CGFloat = 14) {
        var config = UIButton.Configuration.plain()
        
        config.image = UIImage(systemName: imageName)
        
        // Create an Attributed String for the title with the desired font size
        var attributedTitle = AttributedString(title)
        attributedTitle.font = UIFont.systemFont(ofSize: fontSize)
        attributedTitle.foregroundColor = isPrimary ? .white : .theme.accent
        
        config.attributedTitle = attributedTitle
        config.background.backgroundColor = isPrimary ? .theme.accent : .white
        config.imagePlacement = .top
        config.imagePadding = 8
        config.titlePadding = 8
    
        button.configuration = config
        button.layer.borderWidth = 2
        button.layer.borderColor = ColorTheme().accent?.cgColor
        button.tintColor = isPrimary ? .white : .theme.accent

        // Add corner radius directly to the button's layer
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true

        // Add action for the button
        if button == phoneButton {
            button.addTarget(self, action: #selector(phoneButtonTapped), for: .touchUpInside)
        } else if button == websiteButton {
            button.addTarget(self, action: #selector(websiteButtonTapped), for: .touchUpInside)
        } else if button == directionsButton {
            button.addTarget(self, action: #selector(directionsButtonTapped), for: .touchUpInside)
        }
    }
    
  
    // MARK: - Navigation
  
    func goToAppleMaps() {
        
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: business.latitude ?? 0.0, longitude: business.longitude ?? 0.0)))
        
        destination.name = business.name
        
        MKMapItem.openMaps(with: [destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}


// MARK: - Extensions

extension BusinessDetailVC: MKMapViewDelegate {
   
    // Customize annotation view
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let customAnnotation = annotation as? CustomPointAnnotation else { return nil }
        
        let identifier = "CustomMarkerAnnotation"
        var annotationView: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            annotationView = dequeuedView
            annotationView.annotation = customAnnotation
        } else {
            annotationView = MKMarkerAnnotationView(annotation: customAnnotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = false
            
            // Customize the color of the marker
            annotationView.markerTintColor = .theme.accent
            
            // Add a glyph image
            annotationView.glyphImage = UIImage(systemName: "fork.knife")
        }
        
        return annotationView
    }
}

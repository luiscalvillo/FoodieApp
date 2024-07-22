//
//  HomeVC.swift
//  Foodie
//
//  Created by Luis Calvillo on 4/5/23.
//

import UIKit
import MapKit
import CoreLocation
import SDWebImage

class HomeVC: UIViewController {
    
    
    // MARK: - Properties
    
    var locationManager: CLLocationManager?
    
    var currentLocation = [0.0, 0.0]
    var latitude = 0.0
    var longitude = 0.0
    
    var businesses: [Business] = []
    
    // Segmented Control
    var segmentedControl = UISegmentedControl()
    var segmentedControlView = UIView()
    
    var mapViewIsVisible = true
    var listViewIsVisible = false
    
    // Map View
    let mapView = MKMapView()
    
    var customPointAnnotation: CustomPointAnnotation!
    var selectedAnnotation: CustomPointAnnotation?
    
    // Popup View
    var popUpView = UIView()
    let businessPopUpStackView = UIStackView()
    let businessInformationStackView = UIStackView()
    let businessImageView = UIImageView()
    let businessNameLabel = UILabel()
    let addressLabel = UILabel()
    let distanceLabel = UILabel()
    var ratingLabel = UILabel()
    var ratingLabelText = ""
    
    var isPopUpViewVisible = false
    
    let margin: CGFloat = 16
    let popUpViewHeight: CGFloat = 150
    
    // Table View
    var tableView = UITableView()
    

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        setupLocationManager()
        configureSegmentedControl()
        configureMapView()
        configureTableView()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
        createBusinessPopUpView()
        hidePopUpView()
        addPopUpViewTapGesture()
        toggleBetweenMapAndListView()
    }
    
    // MARK: - Setup
    
    func setupView() {
        self.title = "Foodie"
        self.view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(false, animated: false )
    }
    
    func addPopUpViewTapGesture() {
        let popUpViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePopUpViewScreenTap(sender:)))
        popUpView.addGestureRecognizer(popUpViewTapGesture)
    }
    
    func toggleBetweenMapAndListView() {
        UIView.animate(withDuration: 0.5) {
            if self.mapViewIsVisible == true {
                self.mapView.alpha = 1
                self.tableView.alpha = 0
            } else {
                self.mapView.alpha = 0
                self.tableView.alpha = 1
            }
        }
    }
    
    func configureMapView() {
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: segmentedControlView.bottomAnchor, constant: 0),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
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
            customPointAnnotation.rating = business.rating
            customPointAnnotation.phone = business.phone
            customPointAnnotation.displayPhone = business.displayPhone
            
            guard let lat = business.latitude, let lon = business.longitude else { return }
            customPointAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            mapView.addAnnotation(customPointAnnotation)
        }
    }
    
    func createBusinessPopUpView() {
        
        let width = view.self.frame.width
        
        // Pop Up View
        popUpView = UIView(frame: CGRect(x: 8, y: 0, width: width - 16, height: popUpViewHeight))
        popUpView.layer.cornerRadius = 16
        popUpView.clipsToBounds = true
        popUpView.backgroundColor = .white
        popUpView.layer.zPosition = 2
        self.view.addSubview(popUpView)
        
        // Image
        businessImageView.contentMode = .scaleAspectFill
        businessImageView.frame.size.width = 150
        businessImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        businessImageView.clipsToBounds = true
        
        // Name
        businessNameLabel.text = ""
        businessNameLabel.textColor = .black
        businessNameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        // Address
        addressLabel.text = ""
        addressLabel.textColor = .black
        addressLabel.font = UIFont.systemFont(ofSize: 18)
        
        // Distance
        distanceLabel.text = ""
        distanceLabel.textColor = .black
        distanceLabel.font = UIFont.systemFont(ofSize: 16)
        
        // Add the labels to the stack view from an array
        [businessNameLabel, ratingLabel, addressLabel, distanceLabel].forEach {
            businessInformationStackView.addArrangedSubview($0)
        }
        
        // Business Information Stack View
        businessInformationStackView.axis = .vertical
        businessInformationStackView.alignment = .fill
        businessInformationStackView.distribution = .fillProportionally
        businessPopUpStackView.addArrangedSubview(businessImageView)
        businessPopUpStackView.addArrangedSubview(businessInformationStackView)
        popUpView.addSubview(businessPopUpStackView)
        
        // Business Pop Up Stack View
        businessPopUpStackView.axis = .horizontal
        businessPopUpStackView.alignment = .fill
        businessPopUpStackView.distribution = .fill
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
        
        // Slide down popup view to show it
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 2.0, options: .curveEaseIn, animations: {
            self.popUpView.frame.origin.y = 172
        }, completion: nil)
    }
    
    func hidePopUpView() {
        
        isPopUpViewVisible = false
        
        // Slide up popup view to hide it
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 2.0, options: .curveEaseIn, animations: {
            self.popUpView.frame.origin.y = -200
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func handlePopUpViewScreenTap(sender: UITapGestureRecognizer) {
        goToBusinessDetailVC()
    }
    
    func configureSegmentedControl() {
        
        // Segmented Control View
        
        view.addSubview(segmentedControlView)
        
        segmentedControlView.backgroundColor = UIColor(named: "AccentColor")
        segmentedControlView.translatesAutoresizingMaskIntoConstraints = false
        segmentedControlView.layer.zPosition = 10
        
        NSLayoutConstraint.activate([
            segmentedControlView.topAnchor.constraint(equalTo: view.topAnchor, constant: 98),
            segmentedControlView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            segmentedControlView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            segmentedControlView.heightAnchor.constraint(equalToConstant: 68)
        ])
        
        // Segmented Control
        
        let segmentItems = ["Map", "List"]
        segmentedControl = UISegmentedControl(items: segmentItems)
        segmentedControl.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControlView.addSubview(segmentedControl)
        
        segmentedControl.tintColor = .white
        segmentedControl.backgroundColor = UIColor(named: "AccentColor")?.withAlphaComponent(0.50)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: segmentedControlView.topAnchor, constant: 4),
            segmentedControl.leadingAnchor.constraint(equalTo: segmentedControlView.leadingAnchor, constant: 4),
            segmentedControl.trailingAnchor.constraint(equalTo: segmentedControlView.trailingAnchor, constant: -4),
            segmentedControl.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // Segmented Control Font Attributes
        let font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        let normalAttribute: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(normalAttribute, for: .normal)
        
        let selectedAttribute: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: UIColor(named: "AccentColor") as Any]
        segmentedControl.setTitleTextAttributes(selectedAttribute, for: .selected)
    }
    
    @objc
    func valueChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            UIView.animate(withDuration: 0.5) {
                self.mapView.alpha = 1
                self.tableView.alpha = 0
                self.mapViewIsVisible = true
                self.listViewIsVisible = false
            }
        case 1:
            UIView.animate(withDuration: 0.5) {
                self.mapView.alpha = 0
                self.tableView.alpha = 1
                self.mapViewIsVisible = false
                self.listViewIsVisible = true
                
                if self.isPopUpViewVisible {
                    self.hidePopUpView()
                }
            }
        default:
            break
        }
    }
    
    func configureTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(BusinessCell.self, forCellReuseIdentifier: BusinessCell.reuseID)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segmentedControlView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
    }
    
    private func setupMapView() {
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.center = view.center
        
        let mapViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapViewScreenTap(sender:)))
        mapView.addGestureRecognizer(mapViewTapGesture)
    }
    
    @objc 
    func handleMapViewScreenTap(sender: UITapGestureRecognizer) {
        if isPopUpViewVisible {
            hidePopUpView()
        }
    }
    
    
    // MARK: - Navigation
    
    func goToBusinessDetailVC() {
        guard let selectedAnnotation = self.selectedAnnotation else { return }
        guard let business = businessList.first(where: { $0.latitude == selectedAnnotation.latitude && $0.longitude == selectedAnnotation.longitude }) else { return }
        
        let businessDetailVC = BusinessDetailVC(business: business)
        let navVC = UINavigationController(rootViewController: businessDetailVC)
        
        self.present(navVC, animated: true)
    }
}


// MARK: - Extensions

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businessList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BusinessCell.reuseID, for: indexPath) as! BusinessCell
        let business = businessList[indexPath.row]
        
        cell.nameLabel.text = business.name
        cell.addressLabel.text = business.address
        cell.distanceLabel.text = "\(String(describing: business.distance?.getMiles())) mi"
        
        let businessDistanceInMiles = business.distance!.getMiles()
        let roundedDistanceInMiles = String(format: "%.2f", ceil(businessDistanceInMiles * 100) / 100)
        
        cell.distanceLabel.text = roundedDistanceInMiles + " mi"
        cell.ratingLabel.text = createStarRatings(rating: business.rating, ratingLabelText: ratingLabelText)
        
        let businessImageUrl = businessList[indexPath.row].imageURL
        let imageView: UIImageView = cell.businessImageView
        
        imageView.sd_setImage(with: URL(string: businessImageUrl!), placeholderImage: nil)
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 148
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let businessDetailVC = BusinessDetailVC(business: businessList[indexPath.row])
        
        self.navigationController?.pushViewController(businessDetailVC, animated: true)
    }
}

extension HomeVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            
            locationManager?.stopUpdatingLocation()
            
            if let lat = locationManager?.location?.coordinate.latitude, let lon = locationManager?.location?.coordinate.longitude {
                latitude = lat
                longitude = lon
                
                businessList = []
                
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    
                    self?.retrieveBusinesses(latitude: lat, longitude: lon, category: "food", limit: 10, sortBy: "distance", locale: "en_US") { (response, error) in
                        
                        guard let self = self else { return }
                        
                        if let response = response {
                            businessList = response
                            
                            // Update UI on the main thread
                            DispatchQueue.main.async { [self] in
                                self.tableView.reloadData()
                                self.addBusinessesToMap()
                            }
                        } else if let error = error {
                            // Handle error
                            DispatchQueue.main.async {
                                self.showError(error)
                            }
                        }
                    }
                }
            }
        } else {
            
        }
    }
    
    private func showError(_ error: Error) {
        // display error
    }
}

extension HomeVC: MKMapViewDelegate {
   
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
            annotationView.glyphImage = SFSymbols.annotation        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let annotation = view.annotation as? CustomPointAnnotation else { return }
                
        self.selectedAnnotation = annotation
        
        // Show the popup view if the map view is visible
        if mapViewIsVisible {
            showPopUpView()
        }
        
        // Skip user location annotation
        guard !(view.annotation is MKUserLocation) else { return }
        
        // Business details in popup view
        businessNameLabel.text = selectedAnnotation?.title
        addressLabel.text = selectedAnnotation?.address
        
        if let distance = selectedAnnotation?.distance {
            let distanceInMiles = distance.getMiles()
            let roundedDistanceInMiles = String(format: "%.2f", ceil(distanceInMiles * 100) / 100)
            distanceLabel.text = roundedDistanceInMiles + " mi"
        }
        
        if let rating = selectedAnnotation?.rating {
            ratingLabel.text = createStarRatings(rating: rating, ratingLabelText: ratingLabelText)
        }
        
        if let imageUrl = selectedAnnotation?.imageUrl, let url = URL(string: imageUrl) {
            businessImageView.sd_setImage(with: url, placeholderImage: nil)
        }
    }
}

class CustomPointAnnotation: MKPointAnnotation {
    var name: String?
    var address: String?
    var coordinates: [String: Double]?
    var imageUrl: String?
    var latitude: Double?
    var longitude: Double?
    var distance: Double?
    var isClosed: Bool?
    var rating: Double?
    var phone: String?
    var displayPhone: String?
    var website: String?
    var hours: [String: Any]?
    
    init(name: String? = nil,
         address: String? = nil,
         coordinates: [String: Double]? = nil,
         imageUrl: String? = nil,
         latitude: Double? = nil,
         longitude: Double? = nil,
         distance: Double? = nil,
         isClosed: Bool? = nil,
         rating: Double? = nil,
         phone: String? = nil,
         displayPhone: String? = nil,
         website: String? = nil,
         hours: [String: Any]? = nil) {
        
        self.name = name
        self.address = address
        self.coordinates = coordinates
        self.imageUrl = imageUrl
        self.latitude = latitude
        self.longitude = longitude
        self.distance = distance
        self.isClosed = isClosed
        self.rating = rating
        self.phone = phone
        self.displayPhone = displayPhone
        self.website = website
        self.hours = hours
        
        super.init()
    }
}

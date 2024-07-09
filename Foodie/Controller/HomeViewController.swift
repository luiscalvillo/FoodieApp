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
    
    var tableView = UITableView()

    var mapViewIsVisible = true
    var listViewIsVisible = false
    
    var segmentedControl = UISegmentedControl()
        
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(BusinessCell.self, forCellReuseIdentifier: BusinessCell.reuseID)
        
        self.title = "Foodie"
        self.view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(false, animated: false )
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.5) {
            if self.mapViewIsVisible == true {
                self.mapView.alpha = 1
                self.tableView.alpha = 0
            } else {
                self.mapView.alpha = 0
                self.tableView.alpha = 1
            }
        }
        
        configureSegmentedControl()
        configureMapView()
        configureTableView()
        createBusinessPopUpView()
        hidePopUpView()
        
        let popUpViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePopUpViewScreenTap(sender:)))
        popUpView.addGestureRecognizer(popUpViewTapGesture)
    }
    
    func configureMapView() {
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 0),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.center = view.center
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
            
            if let coordinates = business.coordinates,
               let lat = coordinates["latitude"],
               let lon = coordinates["longitude"] {
                customPointAnnotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                mapView.addAnnotation(customPointAnnotation)
            }
        }
    }
    
    func createBusinessPopUpView() {
        
        let width = view.self.frame.width
        let originY: CGFloat = view.frame.height - popUpViewHeight
        
        // Pop Up View
        popUpView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: popUpViewHeight))
        popUpView.layer.cornerRadius = 16
        popUpView.clipsToBounds = true
        popUpView.backgroundColor = .white
        self.view.addSubview(popUpView)
        
        // Image
        businessImageView.contentMode = .scaleAspectFill
        businessImageView.frame.size.width = 150
        businessImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        businessImageView.clipsToBounds = true
        
        // Name
        businessNameLabel.text = ""
        businessNameLabel.textColor = .black
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
        
        businessInformationStackView.addArrangedSubview(businessNameLabel)
        businessInformationStackView.addArrangedSubview(ratingLabel)
        businessInformationStackView.addArrangedSubview(addressLabel)
        businessInformationStackView.addArrangedSubview(distanceLabel)
        
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
        
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 2.0, options: .curveEaseIn, animations: {
            self.popUpView.frame.origin.y = self.view.frame.height - self.popUpViewHeight
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
    
    func configureSegmentedControl() {
        
        let segmentItems = ["Map", "List"]
        segmentedControl = UISegmentedControl(items: segmentItems)
        segmentedControl.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
        
        segmentedControl.selectedSegmentIndex = 0
        view.addSubview(segmentedControl)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            segmentedControl.heightAnchor.constraint(equalToConstant: 60)
        ])
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
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
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
    
    
    
    // MARK: - Navigation
    
    func goToBusinessDetailVC() {
        
        let businessDetailVC = BusinessDetailVC()
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
        
        if let businessRating = selectedAnnotation?.rating {
            businessDetailVC.businessRating = businessRating
        }
        
        if let displayPhone = selectedAnnotation?.displayPhone {
            businessDetailVC.displayPhone = displayPhone
        }
        
        if let phone = selectedAnnotation?.phone {
            businessDetailVC.phone =  phone
        }
        
        if let website = selectedAnnotation?.website {
            businessDetailVC.website =  website
        }
        
        self.present(navVC, animated: true)
    }
}


// MARK: - Extensions

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
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
        cell.ratingLabel.text = createStarRatings(rating: business.rating)
        
        let businessImageUrl = businessList[indexPath.row].imageURL
        let imageView: UIImageView = cell.businessImageView
    
        imageView.sd_setImage(with: URL(string: businessImageUrl!), placeholderImage: nil)
        
        return cell
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 148
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let businessDetailVC = BusinessDetailVC()
        
        let business = businessList[indexPath.row]
        
        if let businessName = business.name {
            businessDetailVC.name = businessName
        }
        
        if let businessAddress = business.address {
            businessDetailVC.address = businessAddress
        }
        
        if let businessDistance = business.distance {
            businessDetailVC.distance = businessDistance
        }
        if let businessLatitude = business.latitude {
            businessDetailVC.latitude = businessLatitude
        }
        
        if let businessLongitude = business.longitude {
            businessDetailVC.longitude = businessLongitude
        }
        
        if let businessImageURL = business.imageURL {
            businessDetailVC.imageUrl = businessImageURL
        }
        
        if let businessRating = business.rating {
            businessDetailVC.businessRating = businessRating
        }
        
        if let displayPhone = business.displayPhone {
            businessDetailVC.displayPhone =  displayPhone
        }
        
        if let phone = business.phone {
            businessDetailVC.phone =  phone
        }
        
        if let website = selectedAnnotation?.website {
            businessDetailVC.website =  website
        }

        self.navigationController?.pushViewController(businessDetailVC, animated: true)
    }
}

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
                            self.tableView.reloadData()
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
            
            if mapViewIsVisible {
                showPopUpView()
            }
            
            if view .isKind(of: MKUserLocation.self) {
                
            } else {
                businessNameLabel.text = selectedAnnotation?.title
                addressLabel.text = selectedAnnotation?.address
                
                let businessDistanceInMiles = selectedAnnotation?.distance.getMiles()
                let roundedDistanceInMiles = String(format: "%.2f", ceil(businessDistanceInMiles! * 100) / 100)
                
                distanceLabel.text = roundedDistanceInMiles + " mi"
                ratingLabel.text = createStarRatings(rating: selectedAnnotation?.rating)
                
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
    var rating: Double!
    var phone: String!
    var displayPhone: String!
    var website: String!
    var hours: [String : Any]!
}

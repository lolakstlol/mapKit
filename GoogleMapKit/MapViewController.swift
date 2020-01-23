
import UIKit
import GoogleMaps
import GooglePlaces

protocol MapViewControllerDelegate : class {
    func addLikelyPlace(new place: PlaceProtocol)
}

class MapViewController: UIViewController {
    
    //Properties
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 7.0
    weak var delegate : MapViewControllerDelegate?
    var selectedMarker: GMSMarker?
    var selectedPlace: GMSPlace?
    @IBOutlet weak var saveButton: UIButton!
    
    private func setup() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
        let camera = GMSCameraPosition.camera(withLatitude: 50,
                                              longitude: 50,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.isHidden = true
    }
    
    private func mapViewConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: saveButton.bottomAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        mapViewConstraints()
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        guard let marker = selectedMarker, let title = selectedMarker?.title else { return }
        delegate?.addLikelyPlace(new: Place.init(cordinates: marker.position, name: title))
    }

    
}

extension MapViewController : GMSMapViewDelegate, CLLocationManagerDelegate {
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        guard var selectedMarker = selectedMarker else { return }
        mapView.clear()
        selectedMarker = GMSMarker(position: position.target)
        selectedMarker.map = mapView
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        guard var selectedMarker = selectedMarker else { return }
        mapView.clear()
        selectedMarker.map = nil
        selectedMarker = GMSMarker(position: position.target)
        let coder = GMSGeocoder()
        coder.reverseGeocodeCoordinate(selectedMarker.position) { (response, error) in
            if error != nil { return }
            guard let title = response?.firstResult()?.addressLine1() else { return }
            selectedMarker.title = title
        }
        selectedMarker.map = mapView
        mapView.selectedMarker = selectedMarker
    }
    
    
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        let marker = GMSMarker()
        selectedMarker = marker
        marker.position = location.coordinate
        marker.map = mapView
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}



import UIKit
import GoogleMaps
import GooglePlaces

protocol MapViewControllerDelegate: class {
    func addLikelyPlace(new place: PlaceProtocol)
}

class MapViewController: UIViewController {
    
    private struct MapViewControllerConstants {
        static let zoomLevel: Float = 7.0
        static let defaultLat: Double = 53.893
        static let defaultLng: Double = 27.567
        static let locationManagerDistanceFilter: Double = 50
    }
    
    //Properties
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var mapView: GMSMapView!
    private var placesClient: GMSPlacesClient!
    weak var delegate: MapViewControllerDelegate?
    private var currentMarker: GMSMarker!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var MapViewConteiner: GMSMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        guard let marker = currentMarker else { return }
        delegate?.addLikelyPlace(new: Place.init(cordinates: marker.position))
    }
    
    private func locationManagerSetup() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = MapViewControllerConstants.locationManagerDistanceFilter
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    private func mapSetup() {
        let camera = GMSCameraPosition.camera(withLatitude: MapViewControllerConstants.defaultLat,
                                              longitude: MapViewControllerConstants.defaultLng,
                                              zoom: MapViewControllerConstants.zoomLevel)
        mapView = GMSMapView.map(withFrame: MapViewConteiner.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.isHidden = true
        MapViewConteiner.addSubview(mapView)
    }
    
    private func setup() {
        locationManagerSetup()
        mapSetup()
        placesClient = GMSPlacesClient.shared()
        
    }
}

extension MapViewController: GMSMapViewDelegate, CLLocationManagerDelegate {
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        mapView.clear()
        currentMarker = GMSMarker(position: position.target)
        currentMarker.map = mapView
        mapView.selectedMarker = currentMarker
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        mapView.clear()
        currentMarker = GMSMarker(position: position.target)
        let currentPlace = Place.init(cordinates: currentMarker.position)
        currentPlace.getName { (name) in
            self.currentMarker?.title = name
            self.currentMarker.map = mapView
            mapView.selectedMarker = self.currentMarker
        }
        currentMarker.map = mapView
        mapView.selectedMarker = currentMarker
    }
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        let marker = GMSMarker()
        currentMarker = marker
        marker.position = location.coordinate
        marker.map = mapView
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: MapViewControllerConstants.zoomLevel)
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


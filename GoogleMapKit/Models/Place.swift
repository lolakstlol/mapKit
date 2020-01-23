import Foundation
import GoogleMaps
import GooglePlaces

protocol PlaceProtocol{
    var cordinates: CLLocationCoordinate2D { get }
    func getName(completion: @escaping (String) -> Void)
}

struct Place: PlaceProtocol {
    var cordinates: CLLocationCoordinate2D

    func getName(completion: @escaping (String) -> Void) {
        GMSGeocoder().reverseGeocodeCoordinate(cordinates) { (response, error) in
            guard let adress = response?.firstResult()?.addressLine1() else { return }
            completion(adress)
        }
    }
}

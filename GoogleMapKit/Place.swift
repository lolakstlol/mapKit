import Foundation
import GoogleMaps

protocol PlaceProtocol{
    var cordinates: CLLocationCoordinate2D { get }
    var name: String { get }
}

struct Place: PlaceProtocol {
    var cordinates: CLLocationCoordinate2D
    var name: String
}

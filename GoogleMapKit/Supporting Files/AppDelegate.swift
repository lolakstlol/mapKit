
import UIKit
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyAGG_TekVzEqLBioVdQuF3I9UqF4486v7g")
        GMSPlacesClient.provideAPIKey("AIzaSyAGG_TekVzEqLBioVdQuF3I9UqF4486v7g")
        return true
    }
}


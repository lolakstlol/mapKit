import GoogleMaps
import GooglePlaces
import UIKit

class ContainerViewController: UIViewController {
    
    var likelyPlaces : [PlaceProtocol] = []
    var controller : UIViewController!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureListViewController()
    }
    
    @IBAction func listToolBarAction(_ sender: Any) {
        configureListViewController()
    }
    
    @IBAction func mapToolBarAction(_ sender: Any) {
        configureMapViewController()
    }
    
    private func configureMapViewController() {
        if controller != nil {
            controller.removeFromParent()
        }
        let newController = MapViewController()
        newController.delegate = self
        controller = newController
        containerView.addSubview(controller.view)
        self.addChild(controller)
    }
    
    private func configureListViewController() {
        if controller != nil {
            controller.removeFromParent()
        }
        let newController = PlacesViewController()
        //newController.delegate = self
        newController.setPlaces(newPlaces: likelyPlaces)
        controller = newController
        containerView.addSubview(controller.view)
         self.addChild(controller)
    }
    
}

extension ContainerViewController: MapViewControllerDelegate {
    func addLikelyPlace(new place: PlaceProtocol) {
        likelyPlaces.append(place)
    }
}


import GoogleMaps
import GooglePlaces
import UIKit

class ContainerViewController: UIViewController {
    
    var likelyPlaces : [PlaceProtocol] = []
    var controller : UIViewController!
    @IBOutlet weak var mapButton: UIBarButtonItem!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var listButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       configureMapViewController()
    }
    
    @IBAction func listToolBarAction(_ sender: Any) {
        configureListViewController()
    }
    
    @IBAction func mapToolBarAction(_ sender: Any) {
        configureMapViewController()
    }
    
    private func configureMapViewController() {
        mapButton.isEnabled = false
        listButton.isEnabled = true
        let newController = MapViewController()
        newController.delegate = self
        controller = newController
        containerView.subviews.last?.removeFromSuperview()
        containerView.addSubview(controller.view)
        self.addChild(controller)
    }
    
    private func configureListViewController() {
        mapButton.isEnabled = true
        listButton.isEnabled = false
        let newController = PlacesViewController()
        //newController.delegate = self
        newController.setPlaces(newPlaces: likelyPlaces)
        controller = newController
        containerView.subviews.last?.removeFromSuperview()
        containerView.addSubview(controller.view)
        self.addChild(controller)
    }
    
}

extension ContainerViewController: MapViewControllerDelegate {
    func addLikelyPlace(new place: PlaceProtocol) {
        likelyPlaces.append(place)
    }
}


import GoogleMaps
import GooglePlaces
import UIKit

class ContainerViewController: UIViewController {
    
    //Properties
    var likelyPlaces: [PlaceProtocol] = []
    var controller: UIViewController!
    @IBOutlet weak var mapButton: UIBarButtonItem!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var listButton: UIBarButtonItem!
    var isMap = false
    
    //Methods
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
        let newController: MapViewController = MapViewController.loadFromStoryboard()
        newController.delegate = self
        controller = newController
        updateContainerView()
    }
    
    private func updateContainerView() {
        containerView.subviews.last?.removeFromSuperview()
        containerView.addSubview(controller.view)
        self.addChild(controller)
    }
    
    private func configureListViewController() {
        mapButton.isEnabled = true
        listButton.isEnabled = false
        let newController: PlacesViewController = PlacesViewController.loadFromStoryboard()
        newController.setPlaces(newPlaces: likelyPlaces)
        controller = newController
        updateContainerView()
    }
    
}

extension ContainerViewController: MapViewControllerDelegate {
    func addLikelyPlace(new place: PlaceProtocol) {
        likelyPlaces.append(place)
    }
}


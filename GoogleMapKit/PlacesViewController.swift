import GooglePlaces
import UIKit

class PlacesViewController: UIViewController {

    private var places : [PlaceProtocol] = []
    @IBOutlet weak var placesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setPlaces(newPlaces: [PlaceProtocol]) {
        places.append(contentsOf: newPlaces)
    }
    
}

extension PlacesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }
    
    
}

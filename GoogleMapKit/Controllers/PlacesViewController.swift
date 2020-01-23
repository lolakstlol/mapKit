import GooglePlaces
import UIKit

class PlacesViewController: UIViewController {

    private var places: [PlaceProtocol] = []
    @IBOutlet weak var placesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setPlaces(newPlaces: [PlaceProtocol]) {
        places.append(contentsOf: newPlaces)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        placesTableView.reloadData()
    }
}

extension PlacesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        places[indexPath.row].getName { (adress) in
            cell.textLabel?.text = adress
        }
        return cell
    }
}


import UIKit

// MARK: UIViewController
extension UIViewController {
    
    class func loadFromStoryboard<T : UIViewController>() -> T {
        let name = String(describing: T.self)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: name) as? T else {
            fatalError("No VC \(name) SB")
        }
        return viewController
    }
}

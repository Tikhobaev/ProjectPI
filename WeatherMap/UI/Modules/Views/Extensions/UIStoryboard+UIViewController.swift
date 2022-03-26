import UIKit

public protocol StoryboardLoadable {
    static func initFromItsStoryboard() -> Self
}

extension StoryboardLoadable where Self: UIViewController {
    
    public static func initFromItsStoryboard() -> Self {
        let storyboardName = self.typeName
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiate(self)
        return viewController
    }
}

extension UIStoryboard {
    
    public func instantiate<VC: UIViewController>(_ viewController: VC.Type) -> VC {
        guard let vc = self.instantiateInitialViewController() as? VC else {
            fatalError("Couldn't instantiate \(type(of: VC.self))")
        }

        return vc
    }
}

extension UIViewController: StoryboardLoadable, NameDescribable {
}

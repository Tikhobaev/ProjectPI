import UIKit

public protocol BaseRouting {
    
    var navigationController: UINavigationController { get }
}

public class BaseRouter {
    
    public let navigationController: UINavigationController
    
    init() {
        let nvc = UINavigationController()
        nvc.navigationBar.isHidden = true
        nvc.modalPresentationStyle = .fullScreen
        //disable pop swipe from left to right
        nvc.interactivePopGestureRecognizer?.isEnabled = false
        
        self.navigationController = nvc
    }
}

extension BaseRouter: BaseRouting {
    
    
    public func presentPleaseRegisterViewController(_ completion: (() -> Void)?) {
        if (navigationController.viewControllers.last?.presentedViewController) != nil {
            return
        }
        
        let vc = BaseViewController()
        
        let currentVC = navigationController.viewControllers.last!
        currentVC.definesPresentationContext = true
        currentVC.present(vc, animated: true, completion: completion)
    }
}

//
//  MainTabBarViewController.swift
//  WeatherApp
//
//  Created by Илья Соловьёв on 08.10.2020.
//  Copyright © 2020 Globus Ltd. All rights reserved.
//

import UIKit

public protocol MainTabBarRouting: BaseRouting {
    var currentLocationFlowRouter: CurrentLocationFlowRouting! { get }
    var citiesFlowRouter: CitiesFlowRouting! { get }
}

final class MainTabBarViewController: BaseViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tabBar: UITabBar!
    
    lazy var router: MainTabBarRouting = {
        MainTabBarRouter(with: self)
    }()
    
    var viewControllers: [UIViewController]!
    var selectedIndex: Int = 0 {
        didSet {
            let previousVC = viewControllers[oldValue]
            previousVC.willMove(toParent: nil)
            previousVC.view.removeFromSuperview()
            previousVC.removeFromParent()
            
            let vc = viewControllers[selectedIndex]
            addChild(vc)
            vc.view.frame = contentView.bounds
            contentView.addSubview(vc.view)
            vc.didMove(toParent: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.delegate = self
        
        router.currentLocationFlowRouter.presentCurrentLocationViewController(nil)
        router.citiesFlowRouter.presentCitiesViewController(nil)
        
        viewControllers = [
            router.citiesFlowRouter.navigationController,
            router.currentLocationFlowRouter.navigationController
        ]
        
        tabBar.selectedItem = tabBar.items?.first
        selectedIndex = 0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MainTabBarViewController: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = tabBar.items?.firstIndex(of: item)
        
        selectedIndex = index ?? 0
    }
}

//
//  CurrentLocationFlowRouter.swift
//  WeatherApp
//
//  Created by Илья Соловьёв on 08.10.2020.
//  Copyright © 2020 Globus Ltd. All rights reserved.
//

import Foundation

public protocol CurrentLocationFlowRouting: BaseRouting {
    func presentCurrentLocationViewController(_ completion: (()->Void)?)
}

final class CurrentLocationFlowRouter: BaseRouter {
    
    let mainTabBarRouter: MainTabBarRouting
    
    init(with mainTabBarRouter: MainTabBarRouting) {
        self.mainTabBarRouter = mainTabBarRouter
        
        super.init()
    }
}

extension CurrentLocationFlowRouter: CurrentLocationFlowRouting {
    
    func presentCurrentLocationViewController(_ completion: (() -> Void)?) {
        if let presentedRVC = navigationController.viewControllers.filter({ $0 is CurrentLocationViewController}).first {
            navigationController.popToViewController(presentedRVC, animated: true)
        } else {
            let vc = CurrentLocationViewController.initFromItsStoryboard()
            vc.viewModel = CurrentLocationViewModel()
            vc.router = self
            vc.modalPresentationStyle = .fullScreen
            
            if navigationController.viewControllers.count == 0 {
                navigationController.viewControllers.append(vc)
            } else {
                navigationController.pushViewController(vc, animated: true)
            }
        }
    }
    
}

extension CurrentLocationFlowRouter: CurrentLocationViewControllerRouting {
    
}

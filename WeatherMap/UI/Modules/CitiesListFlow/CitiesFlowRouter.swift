//
//  CitiesFlowRouter.swift
//  WeatherApp
//
//  Created by Илья Соловьёв on 08.10.2020.
//  Copyright © 2020 Globus Ltd. All rights reserved.
//

import Foundation

public protocol CitiesFlowRouting: BaseRouting {
    func presentCitiesViewController(_ completion: (()->Void)?)
}

final class CitiesFlowRouter: BaseRouter {
    
    let mainTabBarRouter: MainTabBarRouting
    
    init(with mainTabBarRouter: MainTabBarRouting) {
        self.mainTabBarRouter = mainTabBarRouter
        
        super.init()
    }
}

extension CitiesFlowRouter: CitiesFlowRouting {
    
    func presentCitiesViewController(_ completion: (() -> Void)?) {
        if let presentedRVC = navigationController.viewControllers.filter({ $0 is CitiesViewController}).first {
            navigationController.popToViewController(presentedRVC, animated: true)
        } else {
            let vc = CitiesViewController.initFromItsStoryboard()
            vc.viewModel = CitiesViewModel()
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

extension CitiesFlowRouter: CitiesViewControllerRouting {
    
    func presentCityWeatherViewController(cityWeatherModel: CityWeatherModel?, _ completion: (() -> Void)?) {
        if let presentedVC = navigationController.viewControllers.filter({ $0 is CityWeatherViewController}).first {
            navigationController.popToViewController(presentedVC, animated: true)
        } else {
            let vc = CityWeatherViewController.initFromItsStoryboard()
            vc.viewModel = CityWeatherViewModel(cityWeatherModel: cityWeatherModel)
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
    

extension CitiesFlowRouter: CityWeatherViewRouting {
    func navigateBack(animated: Bool, _ completion: (() -> Void)?) {
        let topVC = navigationController.topViewController
        if let presentedVC = topVC?.presentedViewController {
            presentedVC.dismiss(animated: animated, completion: completion)
            return
        }
        navigationController.popViewController(animated: animated)
        completion?()
    }
}

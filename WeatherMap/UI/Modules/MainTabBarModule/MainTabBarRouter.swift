//
//  MainTabBarRouter.swift
//  WeatherApp
//
//  Created by Илья Соловьёв on 08.10.2020.
//  Copyright © 2020 Globus Ltd. All rights reserved.
//

import Foundation

final class MainTabBarRouter: BaseRouter {
    
    weak var mainTabBarViewController: MainTabBarViewController?

    var currentLocationFlowRouter: CurrentLocationFlowRouting!
    var citiesFlowRouter: CitiesFlowRouting!
 
    init(with mainTabBarViewController: MainTabBarViewController) {
        self.mainTabBarViewController = mainTabBarViewController
        
        super.init()
        
        self.currentLocationFlowRouter = CurrentLocationFlowRouter(with: self)
        self.citiesFlowRouter = CitiesFlowRouter(with: self)
    }
   
}

extension MainTabBarRouter: MainTabBarRouting {
    
}

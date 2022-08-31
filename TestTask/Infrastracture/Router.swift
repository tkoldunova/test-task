//
//  Router.swift
//  TestTaskNatife
//
//  Created by Tanya Koldunova on 25.08.2022.
//

import UIKit

protocol RouterProtocol {
    var navigationController: UINavigationController {get set}
    var builder: BuilderProtocol {get set}
    func presentMainViewController()
    func pushMapViewController(parentVC: ForecastDelegateProtocol)
    func pushSearchViewController(parentVC: ForecastDelegateProtocol)
    func popViewController()
}

class Router: RouterProtocol {
    var navigationController: UINavigationController
    var builder: BuilderProtocol
    
    init(navigationController:UINavigationController, builder: BuilderProtocol) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    func presentMainViewController()  {
        let forecastVC = builder.getForecastViewController(router: self)
        navigationController.viewControllers = [forecastVC]
    }
    
    func pushMapViewController(parentVC: ForecastDelegateProtocol) {
        let mapVC = builder.getMapViewController(parentVC: parentVC, router: self)
        navigationController.pushViewController(mapVC, animated: true)
    }
    
    func pushSearchViewController(parentVC: ForecastDelegateProtocol) {
        let searchVC = builder.getSearchController(parentVc: parentVC, router: self)
        navigationController.pushViewController(searchVC, animated: true)
    }
    
    func popViewController() {
        self.navigationController.popViewController(animated: true)
    }
    
}

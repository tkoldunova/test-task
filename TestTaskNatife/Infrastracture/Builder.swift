//
//  Router.swift
//  TestTaskNatife
//
//  Created by Tanya Koldunova on 24.08.2022.
//

import Foundation
import UIKit

protocol BuilderProtocol {
    func getForecastViewController(router: RouterProtocol)->ForecastViewController
    func getMapViewController(parentVC: ForecastDelegateProtocol, router: RouterProtocol)->MapViewController
    func getSearchController(parentVc: ForecastDelegateProtocol, router: RouterProtocol)->SearchViewController
    }

class Builder: BuilderProtocol {
    func getForecastViewController(router: RouterProtocol)->ForecastViewController {
        let vc = ForecastViewController.instantiateMyViewController(name: .forecast)
        vc.presenter = ForecastPresenter(view: vc, forecastAPI: ForecastNetworkService(), router: router)
        return vc
    }
    
    func getMapViewController(parentVC: ForecastDelegateProtocol, router: RouterProtocol)->MapViewController {
        let vc = MapViewController.instantiateMyViewController(name: .map)
        vc.presenter = MapPresenter(view: parentVC, router: router)
        return vc
    }
    
    func getSearchController(parentVc: ForecastDelegateProtocol, router: RouterProtocol)->SearchViewController {
        let vc = SearchViewController.instantiateMyViewController(name: .search)
        vc.presenter = SearchPresenter(view: vc, delegate: parentVc, router: router)
        return vc
    }

}

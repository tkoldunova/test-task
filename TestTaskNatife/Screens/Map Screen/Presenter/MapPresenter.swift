//
//  MapPresenter.swift
//  MirrorDrawing
//
//  Created by Anastasia Koldunova on 24.08.2022.
//

import Foundation
import MapKit

protocol MapPresenterProtocol: MessageManager {
    init(view: ForecastDelegateProtocol, router: RouterProtocol)
    func setCoordinate(coordinates: CLLocationCoordinate2D)
    func popViewController()
}


class MapPresenter : MapPresenterProtocol {

    weak var delegate: ForecastDelegateProtocol?
    private var router: RouterProtocol
    
    required init(view: ForecastDelegateProtocol, router: RouterProtocol) {
        self.delegate = view
        self.router = router
    }
    
    func setCoordinate(coordinates: CLLocationCoordinate2D) {
        delegate?.setCoordinates(coordinates: coordinates)
    }
    
    func popViewController() {
        router.popViewController()
    }
    
}

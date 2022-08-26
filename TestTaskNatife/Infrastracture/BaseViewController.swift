//
//  BaseViewController.swift
//  TestTaskNatife
//
//  Created by Tanya Koldunova on 24.08.2022.
//

import UIKit
import MapKit

protocol BaseViewProtocol {
    static func instantiateMyViewController(name: ViewControllerKeys) -> Self
}

class BaseViewController<T>: UIViewController, BaseViewProtocol, CLLocationManagerDelegate {
    
    var presenter: T!
    
    var locationManager = CLLocationManager()
    var userLocation: CLLocation? {
        didSet {
            setActionForUserLocation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            switch locationManager.authorizationStatus {
            case .restricted, .denied:
                print("restricted")
                locationManager.requestLocation()
                setPermisionDeniedMessage()
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
            @unknown default:
                break
            }
        }

    }
    
    func setActionForUserLocation() {}
    
    func setPermisionDeniedMessage() {}

    static func instantiateMyViewController(name: ViewControllerKeys) -> Self {
        let storyboard = UIStoryboard(name: name.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: name.rawValue) as! Self
        return vc
    }
    
    func shallUpdate(location:CLLocation?, userLocation: CLLocation?)->Bool{
        if location == nil{
            return false
        }
        if userLocation == nil{
            return true
        }
        return abs(location!.coordinate.latitude-userLocation!.coordinate.latitude)>0.001 || abs(location!.coordinate.longitude-userLocation!.coordinate.longitude)>0.001
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("got following error from loaction manager")
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if shallUpdate(location: locations.first, userLocation: userLocation) {
        userLocation  = locations.first
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            userLocation = manager.location
        }
    }

}

enum ViewControllerKeys : String {
    case forecast = "Forecast"
    case map = "Map"
    case search = "Search"
}





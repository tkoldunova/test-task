//
//  MapViewController.swift
//  MirrorDrawing
//
//  Created by Anastasia Koldunova on 24.08.2022.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: BaseViewController<MapPresenterProtocol> {

    @IBOutlet weak var mapView: MKMapView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        setTapGestureRecognizer()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func setActionForUserLocation() {
        if let userCoord = userLocation?.coordinate {
            centerMapOnLocation(lat: userCoord.latitude, lon: userCoord.longitude, radius: 3000.0)
        }
    }
   
    private func centerMapOnLocation(lat:Double , lon: Double, radius:Double) {
        let location = CLLocation(latitude: lat, longitude: lon)
        let coordinateRegion = MKCoordinateRegion.init(center: location.coordinate,
                                                       latitudinalMeters: radius * 5.0, longitudinalMeters: radius * 5.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func setTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapDidTapped(_ :)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.numberOfTouchesRequired = 1
        mapView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: @objc function
    @objc func mapDidTapped(_ sender: UITapGestureRecognizer) {
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        let point1 = sender.location(in: self.mapView)
        let tapPoint = self.mapView.convert(point1, toCoordinateFrom: self.view)
        let point = MKPointAnnotation()
        point.coordinate = tapPoint
        self.mapView.addAnnotation(point)
        presenter.setCoordinate(coordinates: tapPoint)
        DispatchQueue.global().asyncAfter(deadline: .now()+1) {
            DispatchQueue.main.async {
                self.presenter.popViewController()
            }
        }
       
    }
}






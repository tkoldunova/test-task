//
//  ForecastViewController.swift
//  TestTaskNatife
//
//  Created by Tanya Koldunova on 24.08.2022.
//

import UIKit
import CoreLocation

class ForecastViewController: BaseViewController<ForecastPresenterProtocol> {
    
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var maxMinLabel: UIView!
    @IBOutlet weak var minMaxTemperatureLabel: UILabel!
    @IBOutlet weak var humidityView: UIView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedView: UIView!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var forecastByTimeCollectionView: UICollectionView!
    @IBOutlet weak var forecastOfAnotherDaysTableView: UITableView! 
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var useCustomLocation: Bool = false
    lazy var overlay = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func setActionForUserLocation() {
        if let coord = userLocation?.coordinate, !useCustomLocation {
        presenter.getWeather(lat: coord.latitude, lon: coord.longitude)
        }
    }
    
    override func setPermisionDeniedMessage() {
        self.showErrorMessage(type: .permissionDenied, actionText: nil, isForever: false, action: nil)
    }
    
    private func animateInOverlay() {
        overlay.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        overlay.backgroundColor = UIColor.black
        overlay.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.overlay.alpha = 0.4
            self.overlay.transform = CGAffineTransform.identity
        }
    }
    
    private func animateOutOverlay() {
        UIView.animate(withDuration: 0.4) {
            self.overlay.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.overlay.alpha = 0
        } completion: { (_) in
            self.overlay.removeFromSuperview()
        }
    }
    
    private func setDelegates() {
        forecastByTimeCollectionView.delegate = presenter
        forecastByTimeCollectionView.dataSource = presenter
        forecastOfAnotherDaysTableView.delegate = presenter
        forecastOfAnotherDaysTableView.dataSource = presenter
    }
    
    @IBAction func openMapButtonPressed(_ sender: Any) {
        presenter.goToMapViewController()
    }
    @IBAction func cityButtonPressed(_ sender: Any) {
        presenter.goToSearchViewController()
    }
}


extension ForecastViewController: ForecastViewProtocol {
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.forecastOfAnotherDaysTableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            self.forecastOfAnotherDaysTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            self.forecastOfAnotherDaysTableView.delegate?.tableView!(self.forecastOfAnotherDaysTableView, didSelectRowAt: indexPath)
        }
    }
    
    func loadingData() {
        self.view.addSubview(overlay)
        animateInOverlay()
        activityIndicator.startAnimating()
    }
    
    func stopLoadingData() {
        activityIndicator.stopAnimating()
        animateOutOverlay()
    }
    
    func setCoordinates(coordinates: CLLocationCoordinate2D) {
        useCustomLocation = true
        presenter.getWeather(lat: coordinates.latitude, lon: coordinates.longitude)
    }
    
    func reloadCollectionView() {
            self.forecastByTimeCollectionView.reloadData()
    }
    
    func setUpCityLabel(cityName: String) {
            self.cityButton.setTitle(cityName, for: .normal)
    }
    
    func setUpWeatherData(_ model: ForecastModel) {
        DispatchQueue.main.async {
            let date = Date(timeIntervalSince1970: TimeInterval(model.date))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EE, dd MMMM"
            self.dateLabel.text = dateFormatter.string(from: date)
            self.minMaxTemperatureLabel.text = model.getMinMaxTemp()
            self.humidityLabel.text = String(format: "%.1f", model.humidity) + " %"
            self.windSpeedLabel.text = String(format: "%.1f", model.windSpeed) + " km/h"
            if let iconImage = model.getWeatherIcon() {
                self.weatherImageView.image = iconImage.withRenderingMode(.alwaysTemplate)
                self.weatherImageView.tintColor = UIColor.white
            }
        }
    }
    
}






//
//  ForecastPresenter.swift
//  TestTaskNatife
//
//  Created by Tanya Koldunova on 24.08.2022.
//

import UIKit
import CoreLocation

protocol ForecastDelegateProtocol: MessageManager {
   func setCoordinates(coordinates: CLLocationCoordinate2D)
}

protocol ForecastViewProtocol: ForecastDelegateProtocol {
    func reloadTableView()
    func reloadCollectionView()
    func setUpCityLabel(cityName: String)
    func loadingData()
    func stopLoadingData()
    func setUpWeatherData(_ model: ForecastModel)
}

protocol ForecastPresenterProtocol: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    init(view: ForecastViewProtocol, forecastAPI: ForecastNetworkServiceProtocol, router: RouterProtocol)
    func getWeather(lat: Double, lon:Double)
    func getThreeHourForecast(date:String)
    func goToSearchViewController()
    func goToMapViewController() 
}

class ForecastPresenter: NSObject, ForecastPresenterProtocol {
    weak var view: ForecastViewProtocol?
    private var forecastAPI: ForecastNetworkServiceProtocol
    private var daysForecastModel: [ForecastModel] = [ForecastModel]()
    private var threeHourForecastModel: [ForecastModel] = [ForecastModel]()
    private var forecast: ListForecastModel?
    private var router: RouterProtocol
   
    required init(view: ForecastViewProtocol, forecastAPI: ForecastNetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.forecastAPI = forecastAPI
        self.router = router
    }

    func getWeather(lat: Double, lon:Double) {
        view?.loadingData()
        forecastAPI.getWeather(lat: lat, lon: lon, completion: { model, error in
            guard let model = model else {return}
            self.daysForecastModel = model.getForecastFiveDays()
            self.forecast = model
            DispatchQueue.main.async {
                self.view?.stopLoadingData()
                self.view?.setUpCityLabel(cityName: model.cityName)
                self.view?.reloadTableView()
            }
        })
    }
    
    func getThreeHourForecast(date:String) {
        guard let forecast = forecast else {return}
        threeHourForecastModel = forecast.getThreeHourForecast(date: date)
    }
    
    func goToSearchViewController() {
        guard let view = view else {return}
        router.pushSearchViewController(parentVC: view)
    }
    
    func goToMapViewController() {
        guard let view = view else {return}
        router.pushMapViewController(parentVC: view)
    }
    
}

extension ForecastPresenter: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysForecastModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "day forecast cell", for: indexPath) as! DayForecastTableViewCell
        cell.configure(timeInterval: daysForecastModel[indexPath.row].date, minMaxTemp: daysForecastModel[indexPath.row].getMinMaxTemp(), image: daysForecastModel[indexPath.row].getWeatherIcon())
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if daysForecastModel.count > indexPath.row {
        getThreeHourForecast(date: daysForecastModel[indexPath.row].getDate())
            view?.setUpWeatherData(daysForecastModel[indexPath.row])
            view?.reloadCollectionView()
    }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
}

extension ForecastPresenter: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return threeHourForecastModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourForecatsCell", for: indexPath) as! HourForecastCollectionViewCell
            cell.configure(time: threeHourForecastModel[indexPath.row].getTime(), temperature: threeHourForecastModel[indexPath.row].getConvertedTemp(), image: threeHourForecastModel[indexPath.row].getWeatherIcon())
        
        return cell
    }
    
    func  collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 100)
    }
}

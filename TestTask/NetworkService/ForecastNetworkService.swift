//
//  ForecastServiceManager.swift
//  TestTaskNatife
//
//  Created by Tanya Koldunova on 24.08.2022.
//

import Foundation

protocol ForecastNetworkServiceProtocol {
    func getWeather(lat:Double, lon:Double, completion: @escaping(ListForecastModel?, Error?)->Void)
}

class ForecastNetworkService: NetworkServiceManager, ForecastNetworkServiceProtocol {
    func getWeather(lat:Double, lon:Double, completion: @escaping(ListForecastModel?, Error?)->Void) {
        jsonGetRequest(url: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=b25a79b47aaa7930a31ff4db4dfea7f2", returningType: ListForecastModel.self) { model, error in
            completion(model, error)
        }
    }
}

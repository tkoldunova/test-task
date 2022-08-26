//
//  ForecastModel.swift
//  TestTaskNatife
//
//  Created by Tanya Koldunova on 24.08.2022.
//

import UIKit

public struct ListForecastModel: Decodable {
    public let list: [ForecastModel]
    public let cityName: String
    public let country:String
    
    enum CodingKeys: String, CodingKey {
        case list
        case city = "city"
    }
    
    enum CityCodingKeys: String, CodingKey {
        case cityName = "name"
        case country = "country"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.list = try values.decode([ForecastModel].self, forKey: .list)
        let cityInfo =  try values.nestedContainer(keyedBy: CityCodingKeys.self, forKey: .city)
        self.cityName = try cityInfo.decode(String.self, forKey: .cityName)
        self.country = try cityInfo.decode(String.self, forKey: .country)
    }
    
    func getForecastFiveDays() -> [ForecastModel] {
        return Array(Set(list)).sorted { el, el2 in
            el.date<el2.date
        }
    }
    
    func getThreeHourForecast(date: String) -> [ForecastModel] {
        return list.filter { model in
            return model.getDate().starts(with: date.components(separatedBy: " ")[0])
        }
    }
}


public struct ForecastModel: Decodable, Hashable {
    public let weather: [WeatherModel]
    public let temp: Double
    public let minTemp: Double
    public let maxTemp: Double
    public let humidity: Double
    public let windSpeed: Double
    public let date: Int
   
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(getDate())
    }
    
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case weather
        case main
        case wind
    }
    
    enum MainCodingKeys: String, CodingKey {
        case temp
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
        case humidity = "humidity"
    }
    enum WindCodingKeys: String, CodingKey {
        case windSpeed = "speed"
    }
    
    enum WeatherType:String {
        case clear = "Clear"
        case clouds = "Clouds"
        case rain = "Rain"
        
        var image: UIImage {
            switch self {
            case .clear:
                return UIImage(named: "clearSkyIcon")!
            case .clouds:
                return UIImage(named: "cloudsIcon")!
            case .rain:
                return UIImage(named: "rainyIcon")!
            }
        }
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.weather = try values.decode([WeatherModel].self, forKey: .weather)
        self.date = try values.decode(Int.self, forKey: .date)
        let mainInfo = try values.nestedContainer(keyedBy: MainCodingKeys.self, forKey: .main)
        self.temp = try mainInfo.decode(Double.self, forKey: .temp)
        self.minTemp = try mainInfo.decode(Double.self, forKey: .minTemp)
        self.maxTemp = try mainInfo.decode(Double.self, forKey: .maxTemp)
        self.humidity = try mainInfo.decode(Double.self, forKey: .humidity)
        let windInfo = try values.nestedContainer(keyedBy: WindCodingKeys.self, forKey: .wind)
        self.windSpeed = try windInfo.decode(Double.self, forKey: .windSpeed)
    }
    
    func getTime() -> String {
        let dateStr = Date(timeIntervalSince1970: TimeInterval(date))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: dateStr)
    }
    
    func getDate() -> String {
        let dateStr = Date(timeIntervalSince1970: TimeInterval(date))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: dateStr)
    }
    
    func getConvertedTemp() -> Double {
        return temp-273.15
    }
    
    func getWeekDay() -> String {
        let dateStr = Date(timeIntervalSince1970: TimeInterval(date))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        print(dateFormatter.string(from: dateStr))
        return dateFormatter.string(from: dateStr)
    }
    
    func getMinMaxTemp()->String {
        return "\(String(format: "%.1f", minTemp-273.15))º/\(String(format: "%.1f", maxTemp-273.15))º"
    }
    
    func getWeatherIcon() -> UIImage? {
        let type = WeatherType(rawValue: weather[0].main)
        guard let type = type else {return nil}
        return type.image
    }
    
}

extension ForecastModel: Equatable {
    public static func == (lhs: ForecastModel, rhs: ForecastModel) -> Bool {
        return lhs.getDate() == rhs.getDate()
    }
}


public struct WeatherModel: Decodable {
    public let main: String
    public let description: String
    
    enum WeatherCodingKeys: String, CodingKey {
        case weather = "main"
        case description = "description"
    }
}

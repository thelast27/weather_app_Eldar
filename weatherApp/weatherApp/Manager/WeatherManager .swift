//
//  weatherMAnager .swift
//  weatherApp
//
//  Created by Eldar Garbuzov on 22.06.22.
//

import Foundation

protocol RestAPIProviderProtocol {
    func getCoordinatesByName(forCity city: String, completionHandler: @escaping (CurrentAndForecastWeather) -> Void)
    func getWeatherForCityCoordinates(long: Double, lat: Double, withLang lang: Languages, withUnitsOfmeasurement units: Units, completionHandler: @escaping (CurrentAndForecastWeather) -> Void)
}

class WeatherManager: RestAPIProviderProtocol {
    func getCoordinatesByName(forCity city: String, completionHandler: @escaping (CurrentAndForecastWeather) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/geo/1.0/direct"
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: weatherApiKey)
        ]
        guard let urlAddress = components.url else { return }
        guard let url = URL(string: "\(urlAddress)") else { return }
            var urlRequest = URLRequest(url: url)
              urlRequest.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                print(error)
            }
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let geocoding = try decoder.decode([Geolocation].self, from: data)
                    guard let long = geocoding.first?.lon,
                          let lat = geocoding.first?.lat else { return }
                    self.getWeatherForCityCoordinates(long: long, lat: lat, withLang: .english, withUnitsOfmeasurement: .celsius) { CurrentAndForecastWeather in
                        completionHandler(CurrentAndForecastWeather)
                    }
                    print(data)
                } catch let error {
                    print(error)
                }
            }
        }
        dataTask.resume()
    }
    
    func getWeatherForCityCoordinates(long: Double, lat: Double, withLang lang: Languages, withUnitsOfmeasurement units: Units, completionHandler: @escaping (CurrentAndForecastWeather) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/onecall"
        components.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(long)"),
            URLQueryItem(name: "appid", value: weatherApiKey),
            URLQueryItem(name: "lang", value: lang.shortName),
            URLQueryItem(name: "units", value: units.main)
        ]
        guard let urlAddress = components.url else { return }
        guard let url = URL(string: "\(urlAddress)") else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print(error)
            }
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let currentWeather = try decoder.decode(CurrentAndForecastWeather.self, from: data)
                 completionHandler(currentWeather)
                } catch let error {
                    print(error)
                }
            }
        }
        dataTask.resume()
    }
    
    var weatherApiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "weatherApiKey") as? String else { return "" }
        return key
    }
    
} //конец класса

enum Units {
    case celsius
    var main: String {
        switch self {
            case .celsius: return "metric"
        }
    }
}

enum Languages {
    case russian
    case english
    
    var shortName: String {
        switch self {
        case .russian: return "ru"
        case .english: return "en"
        }
    }
}

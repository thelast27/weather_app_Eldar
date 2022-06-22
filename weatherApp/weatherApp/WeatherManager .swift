//
//  weatherMAnager .swift
//  weatherApp
//
//  Created by Eldar Garbuzov on 22.06.22.
//

import Foundation


class WeatherManager {
    var weatherApiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "weatherApiKey") as? String else { return "" }
        return key
    }
    
    enum Languages {
        case russian
        case english
        case arabic
        case german
        case french
        case japanese
        case chinese
        case italian
        case ukrainian
        
        var shortName: String {
            switch self {
            case .russian: return "ru"
            case .english: return "en"
            case .arabic: return "ar"
            case .german: return "de"
            case .french: return "fr"
            case .japanese: return "ja"
            case .chinese: return "zh_tw"
            case .italian: return "it"
            case .ukrainian: return "ua"
            }
        }
    }
    
    var completion: ((CurrentAndForecastWeather) -> Void)?
    
    func urlRequest(city: String) {
        let urlAddress = "https://api.openweathermap.org/geo/1.0/direct?q=\(city)&appid=\(weatherApiKey)"
        guard let url = URL(string: urlAddress) else { return }
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
                    self.currentWeather(long: long, lat: lat, withLang: .english)
             
                } catch let error {
                    print(error)
                }
            }
        }
        dataTask.resume()
    }
    
    func currentWeather(long: Double, lat: Double, withLang lang: Languages) {
        let urlAddress = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=daily&appid=\(weatherApiKey)&lang=\(lang.shortName)&units=metric"
        guard let url = URL(string: urlAddress) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { [weak self] data, response, error in
            if let error = error {
                print(error)
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let currentWeather = try decoder.decode(CurrentAndForecastWeather.self, from: data)
                    self?.completion?(currentWeather)
                } catch let error {
                    print(error)
                }
            }
        }
        dataTask.resume()
    }
    
    
} //конец класса


//
//  RealmDataBaseManager .swift
//  weatherApp
//
//  Created by Eldar Garbuzov on 6.07.22.
//

import Foundation
import Realm
import RealmSwift

protocol RealmDataBaseProtocol {
  func receiveData(data: CurrentAndForecastWeather)
    func getData() -> [WeatherForRealm]
}

class RealmManager: RealmDataBaseProtocol {
 
    
    
    var realm: Realm!
    
    init() {
        var configuration = Realm.Configuration()
        configuration.deleteRealmIfMigrationNeeded = true
        do {
            realm = try Realm(configuration: configuration)
        } catch {
            print(error)
        }
    }
    
    func receiveData(data: CurrentAndForecastWeather) {
        let realmCoordinates = Coordinate()
        let realmWeather = WeatherForRealm()
        
        guard let temp = data.current?.temp,
              let time = data.current?.dt,
              let long = data.lon,
              let lat = data.lat,
              let sunrise = data.current?.sunrise,
              let sunset = data.current?.sunset,
              let feelsLike = data.current?.feelsLike,
              let pressure = data.current?.pressure,
              let humidity = data.current?.humidity,
              let dewPoint = data.current?.dewPoint,
              let uvi = data.current?.uvi,
              let clouds = data.current?.clouds,
              let visibility = data.current?.visibility,
              let windSpeed = data.current?.windSpeed,
              let windDeg = data.current?.windDeg,
              let windGust = data.current?.windGust,
              let timeZone = data.timeZone
        else { return }
        
        realmCoordinates.lat = lat
        realmCoordinates.lon = long
        realmWeather.coordinate = realmCoordinates
        realmWeather.temp = temp
        realmWeather.time = time
        realmWeather.sunrise = sunrise
        realmWeather.sunset = sunset
        realmWeather.feelsLike = feelsLike
        realmWeather.pressure = pressure
        realmWeather.humidity = humidity
        realmWeather.dewPoint = dewPoint
        realmWeather.uvi = Double(uvi)
        realmWeather.clouds = clouds
        realmWeather.visibility = visibility
        realmWeather.windSpeed = windSpeed
        realmWeather.windDeg = windDeg
        realmWeather.windGust = windGust
        realmWeather.timeZone = timeZone
        
        do {
            try realm.write({
                realm.add(realmWeather)
            })
        } catch let error {
            print(error)
        }
    }
    
    func getData() -> [WeatherForRealm] {
        try! Realm().objects(WeatherForRealm.self).map{$0}.reversed()
    }
}

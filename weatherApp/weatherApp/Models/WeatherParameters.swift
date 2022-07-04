//
//  WeatherParameters.swift
//  weatherApp
//
//  Created by Eldar Garbuzov on 17.06.22.
//

import Foundation

//разобрали всё, что пришло по погоде с Open Weather

struct CurrentAndForecastWeather: Codable {
    var lat: Double?
    var lon: Double?
    var timeZone: String?
    var timeZoneOffset: Int?
    var current: CurrentWeatherData?
    var hourly: [HourlyWeatherData]?
    var daily: [DailyWeatherData]?

    enum CodingKeys: String, CodingKey {
        case lat, lon, current, hourly, daily
        case timeZone = "timezone"
        case timeZoneOffset = "timezone_offset"
    }
}

struct CurrentWeatherData: Codable {
    var dt: Int?
    var sunrise: Int?
    var sunset: Int?
    var temp: Double?
    var feelsLike: Double?
    var pressure: Int?
    var humidity: Int?
    var dewPoint: Double?
    var uvi: Float?
    var clouds: Int?
    var visibility: Int?
    var windSpeed: Double?
    var windDeg: Int?
    var windGust: Double?
    var weather: [Weather]?
    var pop: Double?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp, pressure, humidity, uvi, clouds, visibility, weather
        case feelsLike = "feels_like"
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
    }
}

struct Weather: Codable {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
}

//
//  Geolocation.swift
//  weatherApp
//
//  Created by Eldar Garbuzov on 22.06.22.
//


// тут у нас всё,что пришло по геоданным с Open Weather 
import Foundation

struct Geolocation: Codable {
    var cityName: String?
    var lat: Double?
    var lon: Double?
    var country: String?
    
    enum CodingKeys: String, CodingKey {
        case lat, lon, country
        case cityName = "name"
    }
}

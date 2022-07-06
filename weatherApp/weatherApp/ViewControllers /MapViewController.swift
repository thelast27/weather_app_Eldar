//
//  MapViewController.swift
//  weatherApp
//
//  Created by Eldar Garbuzov on 25.06.22.
//

import UIKit
import GoogleMaps


class MapViewController: UIViewController {
    
    @IBOutlet weak var nameOfTappedPiont: UILabel!
    @IBOutlet weak var summaryWeatherInfo: UILabel!
    @IBOutlet weak var textWeatherDiscription: UILabel!
    @IBOutlet weak var sunIndexLable: UILabel!
    @IBOutlet weak var borderViewForMap: UIView!
    
    var weatherManagerDelegte: RestAPIProviderProtocol = WeatherManager()
    var weatherParamsDelegate: CurrentAndForecastWeather?
    var realmManager: RealmDataBaseProtocol = RealmManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: 54.029, longitude: 27.597, zoom: 5.0)
        let mapView = GMSMapView.map(withFrame: borderViewForMap.bounds, camera: camera)
        mapView.delegate = self
        borderViewForMap.addSubview(mapView)
        
        
    } // конец дид вью дид лод
} // конец класса

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        weatherManagerDelegte.getWeatherForCityCoordinates(long: coordinate.longitude, lat: coordinate.latitude, withLang: .english, withUnitsOfmeasurement: .celsius) { weatherData in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                guard let temp = weatherData.current?.temp,
                      let sunIndex = weatherData.current?.uvi,
                      let cityName = weatherData.timeZone,
                      let description = weatherData.current?.weather?.first?.description
                else { return }
                self.realmManager.reciveData(data: weatherData)
                self.summaryWeatherInfo.text = "\(Int(temp)) °"
                self.nameOfTappedPiont.text = cityName
                self.textWeatherDiscription.text = "Now \(description)"
                self.sunIndexLable.text = "Sun Index is \(Int(sunIndex))"
            }
        }
    }
}

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
    
    var weatherManagerDelegte = WeatherManager()
    var weatherParamsDelegate = CurrentAndForecastWeather()
    
    
    @IBOutlet weak var borderViewForMap: UIView!
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
       let test =  weatherManagerDelegte.currentWeather(long: coordinate.longitude, lat: coordinate.latitude, withLang: .english, units: .celsius)
         print("HELLO \(test)")
       
         DispatchQueue.main.async {
             guard let temp = self.weatherParamsDelegate.current?.temp,
                   let sunIndex = self.weatherParamsDelegate.current?.uvi,
                   let cityName = self.weatherParamsDelegate.timeZone,
                   let description = self.weatherParamsDelegate.current?.weather?.first?.description
             else { return }
             
             self.summaryWeatherInfo.text = "\(Int(temp)) °"
             self.nameOfTappedPiont.text = cityName
             self.textWeatherDiscription.text = "Now \(description)"
             self.sunIndexLable.text = "Sun Index is \(Double(sunIndex))"
         }
         
        
    }
}

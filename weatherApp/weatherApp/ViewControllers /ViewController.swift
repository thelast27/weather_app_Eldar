//
//  ViewController.swift
//  weatherApp
//
//  Created by Eldar Garbuzov on 17.06.22.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var summaryWeatherInfo: UILabel!
    @IBOutlet weak var currentWeatherImg: UIImageView!
    @IBOutlet weak var cityNameLable: UILabel!
    @IBOutlet weak var textWeatherDiscription: UILabel!
    @IBOutlet weak var sunIndexLable: UILabel!
    @IBOutlet weak var imageViewForBackgroundPic: UIImageView!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var dailyTableView: UITableView!
    
    
    
    var weatherManager: RestAPIProviderProtocol = WeatherManager()
    var currentAndForecustedWeather: CurrentAndForecastWeather?
    var hourlyWeather: [HourlyWeatherData]?
    var dailyWeather: [DailyWeatherData]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hourlyCollectionView.register(UINib(nibName: "HourlyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HourlyWeatherTableViewCell")
        dailyTableView.register(UINib(nibName: "DailyCollectionViewCell", bundle: nil), forCellReuseIdentifier: "DailyCollectionViewCell")
        
        imageViewForBackgroundPic.image = UIImage(named: "backgroundPic")
        
        weatherManager.getCoordinatesByName(forCity: "Dublin") { [weak self] weatherData in
            guard let self = self else { return }
            self.currentAndForecustedWeather = weatherData
            self.dailyWeather = weatherData.daily
            self.hourlyWeather = weatherData.hourly
            self.update()
            
        }
    } //конец вью дид лод
    //    MARK: - update weather data with necessary parametrs
    func update() {
        guard let weather = currentAndForecustedWeather,
              let icon = weather.current?.weather?.first?.icon else { return }
        let iconURL = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
        DispatchQueue.global(qos: .utility).async {
            guard let url = iconURL,
                  let iconData = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                self.currentWeatherImg.image = UIImage(data: iconData)
            }
        }
        DispatchQueue.main.async {
            guard let temp = weather.current?.temp,
                  let sunIndex = weather.current?.uvi,
                  let cityName = weather.timeZone,
                  let description = weather.current?.weather?.first?.description
            else { return }
            
            self.summaryWeatherInfo.text = "\(Int(temp)) °"
            self.cityNameLable.text = cityName
            self.textWeatherDiscription.text = "Now \(description)"
            self.sunIndexLable.text = "Sun Index is \(Double(sunIndex))"
            self.dailyTableView.reloadData()
            self.hourlyCollectionView.reloadData()
            
        }
    }
} //конец класса


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentAndForecustedWeather?.hourly?.count ?? 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyWeatherTableViewCell", for: indexPath) as? HourlyCollectionViewCell else { return
            UICollectionViewCell() }
        if let hourly = hourlyWeather {
            cell.update(date: hourly[indexPath.row])
        }
        return cell
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentAndForecustedWeather?.daily?.count ?? 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCollectionViewCell") as? DailyCollectionViewCell else { return UITableViewCell() }
        if let daily = dailyWeather {
            cell.update(date: daily[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

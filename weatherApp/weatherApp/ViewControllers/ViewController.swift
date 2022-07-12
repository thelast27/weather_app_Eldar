//
//  ViewController.swift
//  weatherApp
//
//  Created by Eldar Garbuzov on 17.06.22.
//

import UIKit

class ViewController: UIViewController {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
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
    var realmManager: RealmDataBaseProtocol = RealmManager()
    
    
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
            self.realmManager.receiveData(data: weatherData)
            guard let weather = self.hourlyWeather else { return }
            self.weatherForecast(hourlyWeather: weather)
            self.removeAllNotification()
            
        }
    } //конец вью дид лод
    //    MARK: - update weather data with necessary parametrs
    func update() {
        guard let weather = currentAndForecustedWeather,
              let icon = weather.current?.weather?.first?.icon else { return }
        let endpoint = Endpoint.getIcon(icon: "\(icon)")
        DispatchQueue.global(qos: .utility).async {
            guard let iconData = try? Data(contentsOf: endpoint.url) else { return }
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
            self.sunIndexLable.text = "Sun Index is \(Int(sunIndex))"
            self.dailyTableView.reloadData()
            self.hourlyCollectionView.reloadData()
            
        }
    }
    //    MARK: - set LocalNotification
    func setLocalNotification(body: String, title: String, dateComponents: DateComponents) {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] isAutorized, error in
            guard let self = self else { return }
            if isAutorized {
                let content = UNMutableNotificationContent()
                content.body = body
                content.title = title
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let identifier = "identifier"
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                
                self.notificationCenter.add(request) { error in
                    if let error = error {
                        print(error)
                    }
                }
            } else if let error = error {
                print(error)
            }
        }
    }
    
    
    func weatherForecast(hourlyWeather: [HourlyWeatherData]) {
        var indexOfNotification = 0
        for hour in hourlyWeather {
            guard let id = hour.weather?.first?.id, let time = hour.dt else { return }
            if indexOfNotification == 0 || indexOfNotification > 3 {
                switch id {
                case 200...232:
                    setLocalNotification(body: "Thunderstorm is coming", title: "Attantion", dateComponents: getDateComponentsFrom(date: time))
                    indexOfNotification = 1
                case 500...531:
                    setLocalNotification(body: "Rain is coming", title: "Attantion", dateComponents: getDateComponentsFrom(date: time))
                    indexOfNotification = 1
                case 600...622:
                    setLocalNotification(body: "Snow is coming", title: "Attantion", dateComponents: getDateComponentsFrom(date: time))
                    indexOfNotification = 1
                default: break
                }
            }
            indexOfNotification += 1
        }
    }
    
    func removeAllNotification() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
    //    MARK: - end local notification
} //конец класса


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentAndForecustedWeather?.hourly?.count ?? 0
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
        currentAndForecustedWeather?.daily?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCollectionViewCell") as? DailyCollectionViewCell, let daily = dailyWeather else { return UITableViewCell() }
        cell.update(date: daily[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

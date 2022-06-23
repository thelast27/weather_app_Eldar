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
    @IBOutlet weak var viewForBackgroundBlurePic: UIView!
    @IBOutlet weak var imageViewForBackgroundPic: UIImageView!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setbackgroundPic()
        weatherManager.urlRequest(city: "Dublin")
        weatherManager.completion = { [weak  self] currentWeather in
            guard let self = self else { return }
            self.update(weather: currentWeather)
        }
    } //конец вью дид лод
    //    MARK: - update weather data with necessary parametrs 
    func update(weather: CurrentAndForecastWeather) {
        guard let icon = weather.current?.weather?.first?.icon else { return }
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
        }
    }
//    MARK: - set background image with blure effect
    func setbackgroundPic() {
        imageViewForBackgroundPic.image = UIImage(named: "backgroundPic")
        
//            let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
//                backgroundImage.image = UIImage(named: "backgroundPic")
//            backgroundImage.contentMode = .bottom
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = viewForBackgroundBlurePic.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            viewForBackgroundBlurePic.addSubview(blurEffectView)
//                self.viewForBackgroundBlurePic.insertSubview(backgroundImage, at: 0)
    }
}//конец класса

//
//  ViewController.swift
//  weatherApp
//
//  Created by Eldar Garbuzov on 17.06.22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
      
     
      if let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=55.5359&lon=27.3400&appid=b61dbfacfdb0c829c7f9b5ee06534d0b&units=metric") {
          var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
          let dataTaks = URLSession.shared.dataTask(with: urlRequest) { data, response, error in

              if let data = data {
                  guard let weatherParametrs = try? JSONDecoder().decode(ResponseBody.self, from: data) else { return }
                  print("In \(weatherParametrs.name) today \(weatherParametrs.main.temp) by Celsius")
              }
          }
          dataTaks.resume()
        }
        
    } //конец вью дид лод
    



    
    
} //конец класса


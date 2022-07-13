//
//  HourlyCollectionViewCell.swift
//  weatherApp
//
//  Created by Eldar Garbuzov on 1.07.22.
//

import UIKit
import SnapKit



class HourlyCollectionViewCell: UICollectionViewCell {
    
    let weatherIcon = UIImageView()
    
    var summaryWeatherInfo = UILabel()
    var textWeatherDiscription = UILabel()

    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        summaryWeatherInfo.text = ""
        summaryWeatherInfo.numberOfLines = 0
        contentView.addSubview(summaryWeatherInfo)
        textWeatherDiscription.text = ""
        textWeatherDiscription.numberOfLines = 0
        contentView.addSubview(textWeatherDiscription)
        contentView.addSubview(weatherIcon)
        
        summaryWeatherInfo.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.right.left.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(8)
        }
        
        weatherIcon.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(summaryWeatherInfo.snp.bottom).inset(16)
        }
        
        textWeatherDiscription.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.left.right.bottom.equalToSuperview().inset(16)
            make.top.equalTo(weatherIcon.snp.bottom).inset(16)
        }
        
        self.backgroundColor = .clear
        self.backgroundColor = .clear.withAlphaComponent(0)
     

    } //end of awake
    
    func update(date: HourlyWeatherData) {
        if let dt = date.dt, let temp = date.temp, let icon = date.weather?.first?.icon {
            let endpoint = Endpoint.getIcon(icon: "\(icon)")
            guard let iconData = try? Data(contentsOf: endpoint.url) else { return }
            summaryWeatherInfo.text = dt.updateDateFormat(dateFormat: .hours)
            weatherIcon.image = UIImage(data: iconData)
            textWeatherDiscription.text = "\(Int(temp))°C"
        }
    }
} //конец класса



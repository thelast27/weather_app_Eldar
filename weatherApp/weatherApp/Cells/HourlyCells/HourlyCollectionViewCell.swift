//
//  HourlyCollectionViewCell.swift
//  weatherApp
//
//  Created by Eldar Garbuzov on 1.07.22.
//

import UIKit
import SnapKit



class HourlyCollectionViewCell: UICollectionViewCell {
    
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
        
        summaryWeatherInfo.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.top.right.left.equalToSuperview().inset(16)
        }
        
        textWeatherDiscription.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.left.right.bottom.equalToSuperview().inset(16)
            make.top.equalTo(summaryWeatherInfo.snp.bottom).inset(16)
        }
        
        self.backgroundColor = .systemMint
     

    } //end of awake
    
    func update(date: HourlyWeatherData) {
        if let dt = date.dt, let temp = date.temp {
            summaryWeatherInfo.text = dt.updateDateFormat(dateFormat: .hours)
            textWeatherDiscription.text = "\(Int(temp)) °C"
        }
    }
} //конец класса



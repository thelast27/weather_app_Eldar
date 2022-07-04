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
            let formatter = DateFormatter()
            let date = formatter.daysFormatt(dt: dt, isTime: true)
            summaryWeatherInfo.text = date
            textWeatherDiscription.text = "\(Int(temp)) °C"
        }
    }
} //конец класса

extension DateFormatter {
    func daysFormatt(dt: Int, isTime: Bool) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let dateFormatter = DateFormatter()
        if isTime {
            dateFormatter.timeStyle = DateFormatter.Style.short
        } else {
            dateFormatter.dateStyle = DateFormatter.Style.medium
        }
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
}

//
//  DailyCollectionViewCell.swift
//  weatherApp
//
//  Created by Eldar Garbuzov on 2.07.22.
//

import UIKit
import SnapKit


class DailyCollectionViewCell: UITableViewCell {
    

    
    var dayLabel = UILabel()
    var tempLabel = UILabel()
    let weatherIcon = UIImageView()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        dayLabel.text = ""
        tempLabel.text = ""
        contentView.addSubview(dayLabel)
        contentView.addSubview(tempLabel)
        contentView.addSubview(weatherIcon)
        
        dayLabel.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalTo(120)
            make.left.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(2)
            
        }
        
        weatherIcon.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalTo(60)
            make.left.equalTo(dayLabel.snp.right).inset(8)
            make.top.bottom.equalToSuperview().inset(2)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalTo(60)
            make.left.equalTo(weatherIcon.snp.right).inset(2)
            make.top.bottom.equalToSuperview().inset(2)
            
    }

        self.backgroundColor = .clear
        
} //end of awake
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func update(date: DailyWeatherData) {
        guard let dt = date.dt, let temp = date.temp?.day, let icon = date.weather?.first?.icon else { return }
        let endpoint = Endpoint.getIcon(icon: "\(icon)")
        guard let iconData = try? Data(contentsOf: endpoint.url) else { return }
        weatherIcon.image = UIImage(data: iconData)
        dayLabel.text = dt.updateDateFormat(dateFormat: .days)
            tempLabel.text = "\(Int(temp)) °C"
    }
    
    
} // end of class

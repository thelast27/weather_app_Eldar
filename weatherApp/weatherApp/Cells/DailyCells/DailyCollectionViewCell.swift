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

    override func awakeFromNib() {
        super.awakeFromNib()
        
        dayLabel.text = ""
        tempLabel.text = ""
        contentView.addSubview(dayLabel)
        contentView.addSubview(tempLabel)
        
        dayLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.top.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(8)
            make.right.equalToSuperview().inset(16)
    }

        self.backgroundColor = .clear
        
} //end of awake
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func update(date: DailyWeatherData) {
        guard let dt = date.dt, let temp = date.temp?.day else { return }
        dayLabel.text = dt.updateDateFormat(dateFormat: .days)
            tempLabel.text = "\(Int(temp)) °C"
    }
    
    
} // end of class

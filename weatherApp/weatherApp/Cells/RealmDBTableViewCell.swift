//
//  RealmDBTableViewCell.swift
//  weatherApp
//
//  Created by Eldar Garbuzov on 6.07.22.
//

import UIKit

class RealmDBTableViewCell: UITableViewCell {
    
    @IBOutlet var coordinatesLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var currentWeatherLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(data: WeatherForRealm) {
        guard let long = data.coordinate?.lon, let lat = data.coordinate?.lat else { return }
        self.coordinatesLabel.text = "Long: \(long) : Lat: \(lat)"
        self.timeLabel.text = data.time.updateDateFormat(dateFormat: .fullTime)
        self.currentWeatherLable.text = "Weather was \(Int(data.temp)) °C"
    }
    
}

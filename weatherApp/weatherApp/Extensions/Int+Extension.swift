//
//  DateFormatExtension .swift
//  weatherApp
//
//  Created by Eldar Garbuzov on 4.07.22.
//

import Foundation

extension Int {
    func updateDateFormat(dateFormat: DateFormat) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = dateFormat.getDateFormat
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
    }
}

enum DateFormat: String {
    case hours
    case days
    case fullTime
    case daysWithoutYear
    
    var getDateFormat: String {
        switch self {
        case .hours: return "HH:mm"
        case .days: return "E"
        case .daysWithoutYear: return "HH MMMM yyyy"
        case .fullTime: return "EEEE, d MMMM yyyy HH:mm:ss"
        }
    }
}

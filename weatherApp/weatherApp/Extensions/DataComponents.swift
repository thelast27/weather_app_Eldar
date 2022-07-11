//
//  DataComponents.swift
//  weatherApp
//
//  Created by Eldar Garbuzov on 11.07.22.
//

import Foundation

func getDateComponentsFrom(date: Int) -> DateComponents {
    let calendar = Calendar.current
    let newDate = Date(timeIntervalSince1970: TimeInterval(date))
    var newDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: newDate)
    guard let minutes = newDateComponents.minute else { fatalError() }
    newDateComponents.minute = minutes - 30
    return newDateComponents
}

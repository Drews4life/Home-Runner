//
//  Extensions.swift
//  Home-Runner
//
//  Created by Andrii Zakharenkov on 2/15/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import Foundation

extension Double {
    func metersToKilometers(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return ((self / 1000) * divisor).rounded() / divisor
    }
}

extension Int {
    func formatTimeDuration() -> String {
        let durationHours = self / 3600
        let durationMinutes = (self % 3600) / 60
        let durationSeconds = ((self % 3600) % 60)
        
        if durationSeconds < 0 {
            return "00:00:00"
        } else {
            if durationHours == 0 {
                return String(format: "%02d:%02d", durationMinutes, durationSeconds)
            } else {
                return String(format: "%02d:%02d:%02d", durationHours, durationMinutes, durationSeconds)
            }
        }
    }
}

extension NSDate {
    func formatDateString() -> String {
        let calendar = Calendar.current
        
        let day = calendar.component(.day, from: self as Date)
        let month = calendar.component(.month, from: self as Date)
        let year = calendar.component(.year, from: self as Date)
        
        return "\(day)/\(month)/\(year)"
    }
}

//
//  Date.swift
//  BookRoom
//
//  Created by Gulati, Mauli on 20/3/20.
//  Copyright © 2020 Gulati, Mauli. All rights reserved.
//

import Foundation

extension Date {
    public func toAmPMTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: self)
    }
    
    public func to24HourTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    public func dateToString(date: Date) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        guard let dayToInt = Int(formatter.string(from: date)) else {
            return ""
        }
        guard let day = numberFormatter.string(from: dayToInt as NSNumber) else {
            return ""
        }
        formatter.dateFormat = "MMM yyyy"
        return "\(String(describing: day)) \(formatter.string(from: self))"
    }
}

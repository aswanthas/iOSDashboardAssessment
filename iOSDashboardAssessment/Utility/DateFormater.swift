//
//  DateFormater.swift
//  iOSDashboardAssessment
//
//  Created by Aswanth K on 29/08/24.
//

import Foundation

func formattedCurrentDate() -> String {
    // Get the current date
    let currentDate = Date()
    
    // Create a DateFormatter
    let dateFormatter = DateFormatter()
    
    // Set the date format to "Friday, January 6th, 2024"
    dateFormatter.dateFormat = "EEEE, MMMM d'th', yyyy"
    
    // Create a DateFormatter to get the day suffix
    let dayFormatter = DateFormatter()
    dayFormatter.dateFormat = "d"
    
    // Get the day of the month
    let day = dayFormatter.string(from: currentDate)
    
    // Determine the day suffix
    let suffix: String
    if day.hasSuffix("1") && !day.hasSuffix("11") {
        suffix = "st"
    } else if day.hasSuffix("2") && !day.hasSuffix("12") {
        suffix = "nd"
    } else if day.hasSuffix("3") && !day.hasSuffix("13") {
        suffix = "rd"
    } else {
        suffix = "th"
    }
    
    // Format the date with the suffix
    let formattedDate = dateFormatter.string(from: currentDate).replacingOccurrences(of: "d'th'", with: "\(day)\(suffix)")
    
    return formattedDate
}

extension String {
    var timeFormat: String? {
        // Define the input date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        // Convert the string to a Date object
        guard let date = dateFormatter.date(from: self) else { return nil }
        
        let calendar = Calendar.current
        let currentDate = Date()
        let isToday = calendar.isDate(currentDate, inSameDayAs: date)
        let sameDay = calendar.isDate(date, inSameDayAs: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        let formattedTime = timeFormatter.string(from: date)
        
        let dateFormatterForDisplay = DateFormatter()
        dateFormatterForDisplay.dateFormat = "dd/MM/yyyy"
        
        if isToday && sameDay {
            return "Today, \(formattedTime)"
        } else if sameDay {
            let formattedDate = dateFormatterForDisplay.string(from: date)
            return "\(formattedDate), \(formattedTime)"
        } else {
            let startDateFormatted = dateFormatterForDisplay.string(from: date)
            let endDateFormatted = dateFormatterForDisplay.string(from: date) // Assuming endDate is different
            return "\(startDateFormatted), \(formattedTime) - \(endDateFormatted), \(formattedTime)"
        }
    }
}

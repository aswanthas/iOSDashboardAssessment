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

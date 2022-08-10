//
//  DateHelper.swift
//  PhotoUploadApp
//
//  Created by Volodymyr Ilkiv on 10.08.2022.
//

import Foundation

// MARK: - DateHelper
class DateHelper {
    
    // MARK: - Public methods
    static func getString(from date: Date, with format: TimeFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.string(from: date)
    }
    
    static func convetDateString(form string: String, fromFormat: TimeFormat, toFormat: TimeFormat) -> String {
        let date = getDate(from: string, format: fromFormat)
        let newDateString = getString(from: date, with: toFormat)
        return newDateString
    }
    
    static func getDate(from string: String, format: TimeFormat, shouldUseLocale: Bool = true) -> Date {
        let formatter = DateFormatter()
        if shouldUseLocale {
            formatter.locale = Locale(identifier: "en_US_POSIX")
        }
        formatter.dateFormat = format.rawValue
        return formatter.date(from: string) ?? Date()
    }
}

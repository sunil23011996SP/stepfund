//
//  Date+Extension.swift
//  Pharma247
//
//  Created by mac100 on 26/09/19.
//  Copyright © 2019 TRooTech. All rights reserved.
//

import Foundation

var isSystemSetFor12Hour: Bool {
    let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)!
    return formatter.contains("a")
}

extension Date {
    
    func daySuffix() -> String {
        
        let calendar = Calendar.current
        
        let day = calendar.component(.day, from: self)
        
        switch day {
        case 11...13: return "th"
        default:
            switch day % 10 {
            case 1: return "st"
            case 2: return "nd"
            case 3: return "rd"
            default: return "th"
            }
        }
    }
    
    func weeksFrom(_ date:Date) -> Int{
        return (Calendar.current as NSCalendar).components(.weekOfYear, from: date, to: self, options: []).weekOfYear!
    }
    
    static func convertUTCStringToDate(_ strDate:String, dateFormat:String) -> Date?
    {
        let formatter:DateFormatter = DateFormatter();
        formatter.dateFormat = dateFormat;
        
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let date = formatter.date(from: strDate);
        return date;
    }
    
    // MARK:- APP SPECIFIC FORMATS
    func app_dateFromString(strDate:String, format:String) -> Date? {
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let dtDate = dateFormatter.date(from: strDate){
            return dtDate
        }
        return nil
    }
    
    
    func app_stringFromDate() -> String {
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let strdt = dateFormatter.string(from: self)
        if let dtDate = dateFormatter.date(from: strdt){
            return dateFormatter.string(from: dtDate)
        }
        return "--"
    }
    
    func app_stringFromDate_timeStamp() -> String{
        return "\(self.hourTwoDigit):\(self.minuteTwoDigit) \(self.ampmValue())  \(self.monthNameShort) \(self.dayTwoDigit)"
    }
    
    
    func getUTCFormateDate(localDate: NSDate) -> String {
        let dateFormatter:DateFormatter = DateFormatter()
        let timeZone: NSTimeZone = NSTimeZone(name: "UTC")!
        dateFormatter.timeZone = timeZone as TimeZone?
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        let dateString: String = dateFormatter.string(from: localDate as Date)
        return dateString
    }
    
    func toString(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        return dateFormatter.string(from: self)
    }
    
    
    static func mergeDates(date: Date, time: Date) -> Date? {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "GMT")!     // Set timezone
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var mergedComponments = DateComponents()
        mergedComponments.year = dateComponents.year!
        mergedComponments.month = dateComponents.month!
        mergedComponments.day = dateComponents.day!
        mergedComponments.hour = timeComponents.hour!
        mergedComponments.minute = timeComponents.minute!
        mergedComponments.second = 00
        
        return calendar.date(from: mergedComponments)
    }
    
    func getDatesBetweenDates(startDate:NSDate, andEndDate endDate:NSDate) -> [NSDate] {
        let gregorian: NSCalendar = NSCalendar.current as NSCalendar;
        let components = gregorian.components(NSCalendar.Unit.day, from: startDate as Date, to: endDate as Date, options: [])
        var arrDates = [NSDate]()
        for i in 0...components.day!{
            arrDates.append(startDate.addingTimeInterval(60*60*24*Double(i)))
        }
        return arrDates
    }
    
    
    func isGreaterThanDate(_ date: Date) -> Bool {
        return self > date
    }
    
    func isLessThanDate(_ date: Date) -> Bool {
        return self < date
    }
    
    func isEqualToDate(_ date: Date) -> Bool {
        return self == date
    }
    
    func isToday() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let selfDate = dateFormatter.string(from: self)
        let todayDate = dateFormatter.string(from: Date())
        return selfDate == todayDate
    }
    
    
    static func stringDate(_ date: String, currentFormat: String, needFormat: String) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = currentFormat
        
        if let newDate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = needFormat
            return dateFormatter.string(from: newDate)
        }
        
        return nil
    }
    
    
    
    // MARK:- TIME
    var timeWithAMPM: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.string(from: self)
    }
    
    var timeWithAMPMSmall: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        return dateFormatter.string(from: self)
    }
    
    
    // MARK:- YEAR
    var yearFourDigit_Int: Int {
        return Int(self.yearFourDigit)!
    }
    
    var yearOneDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y"
        return dateFormatter.string(from: self)
    }
    var yearTwoDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy"
        return dateFormatter.string(from: self)
    }
    var yearFourDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
    
    
    // MARK:- MONTH
    
    var monthOneDigit_Int: Int {
        return Int(self.monthOneDigit)!
    }
    var monthTwoDigit_Int: Int {
        return Int(self.monthTwoDigit)!
    }
    
    var monthOneDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M"
        return dateFormatter.string(from: self)
    }
    var monthTwoDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: self)
    }
    var monthNameShort: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
    var monthNameFull: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    var monthNameFirstLetter: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMMM"
        return dateFormatter.string(from: self)
    }
    
    // MARK:- DAY
    var dayOneDigit_Int: Int {
        return Int(self.dayOneDigit)!
    }
    var dayTwoDigit_Int: Int {
        return Int(self.dayTwoDigit)!
    }
    
    var dayOneDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: self)
    }
    var dayTwoDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
    var dayNameShort: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: self)
    }
    var dayNameFull: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    var dayNameFirstLetter: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEEE"
        return dateFormatter.string(from: self)
    }
    
    
    func weekday() -> Int {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "GMT")!
        return calendar.dateComponents([.weekday], from: self).weekday ?? 1
    }
    
    
    // MARK:- AM PM
    func ampmValue() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        dateFormatter.dateFormat = "a"
        
        if !isSystemSetFor12Hour {
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        }
        
        return dateFormatter.string(from: self)
    }
    
    
    // MARK:- HOUR
    var hourOneDigit_Int: Int {
        return Int(self.hourOneDigit)!
    }
    
    var hourTwoDigit_Int: Int {
        return Int(self.hourTwoDigit)!
    }
    
    var hourOneDigit24Hours_Int: Int {
        return Int(self.hourOneDigit24Hours)!
    }
    
    var hourTwoDigit24Hours_Int: Int {
        return Int(self.hourTwoDigit24Hours)!
    }
    
    var hourOneDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h"
        return dateFormatter.string(from: self)
    }
    
    var hourTwoDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        if !isSystemSetFor12Hour {
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        }
        dateFormatter.dateFormat = "hh"
        return dateFormatter.string(from: self)
    }
    
    var hourOneDigit24Hours: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        dateFormatter.dateFormat = "H"
        return dateFormatter.string(from: self)
    }
    
    var hourTwoDigit24Hours: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        dateFormatter.dateFormat = "HH"
        return dateFormatter.string(from: self)
    }
    
    
    // MARK:- MINUTE
    var minuteOneDigit_Int: Int {
        return Int(self.minuteOneDigit)!
    }
    var minuteTwoDigit_Int: Int {
        return Int(self.minuteTwoDigit)!
    }
    
    var minuteOneDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "m"
        return dateFormatter.string(from: self)
    }
    var minuteTwoDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        if !isSystemSetFor12Hour {
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        }
        dateFormatter.dateFormat = "mm"
        return dateFormatter.string(from: self)
    }
    
    
    // MARK:- SECOND
    var secondOneDigit_Int: Int {
        return Int(self.secondOneDigit)!
    }

    var secondTwoDigit_Int: Int {
        return Int(self.secondTwoDigit)!
    }
    
    var secondOneDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "s"
        return dateFormatter.string(from: self)
    }
    var secondTwoDigit: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ss"
        return dateFormatter.string(from: self)
    }
}

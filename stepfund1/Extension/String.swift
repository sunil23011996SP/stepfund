//
//  String.swift
//  Pharma247
//
//  Created by Sagar Chauhan on 09/08/19.
//  Copyright © 2019 TRooTech. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift

extension String {
    
    //--------------------------------------------------
    // MARK:- Properties
    //--------------------------------------------------
    
    
    // Variable used to get localized key
    var localized: String {
        return LocalizationSystem.sharedInstance.localizedStringForKey(key: self, comment: "")
    }
    
    var htmlAttributedString: NSAttributedString? {
        return try? NSAttributedString(
            data: Data(utf8),
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ], documentAttributes: nil)
    }
    
    //    var localized: String {
    //        if let _ = UserDefaults.standard.string(forKey: "i18n_language") {} else {
    //            // we set a default, just in case
    //            UserDefaults.standard.set("fr", forKey: "i18n_language")
    //            UserDefaults.standard.synchronize()
    //        }
    //
    //        let lang = UserDefaults.standard.string(forKey: "i18n_language")
    //
    //        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
    //        let bundle = Bundle(path: path!)
    //
    //        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    //    }
    
    // Trimiming white space and newlines
    var trim: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // This code will add line spacing for multine string
    var addLineSpacing: NSAttributedString {
        
        // Create paragram instance to add line spacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        // Set attribute string for message
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont(name: FontName.MADETOMMY, size: 17)!,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor: UIColor(hex: "#737373")
        ]
        
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    var isBackspace: Bool {
        let char = self.cString(using: String.Encoding.utf8)!
        return strcmp(char, "\\b") == -92
    }
    
    var toDouble: Double {
        return (self as NSString).doubleValue
    }
    
    var toInt: Int {
        return (self as NSString).integerValue
    }
    
    func valueWithDollar() -> String {
        if let doubleValue = Double(self) {
            return String(format: "$%.2f", doubleValue)
        } else {
            return String(format: "$%.2f", 0.00)
        }
    }
    
    func htmlString() -> NSAttributedString? {
        if let data = self.data(using: .unicode) {
            if let attributeString = try? NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html
                ], documentAttributes: nil) {
                return attributeString
            }
        }
        return nil
    }
    
    
    //--------------------------------------------------
    // MARK:- Encrypt String
    //--------------------------------------------------
    
    func encrypt() -> String  {
        if let aes = try? AES(key: "0123456789abcdef", iv: "fedcba9876543210"),
            let encrypted = try? aes.encrypt(Array(self.utf8)) {
            return encrypted.toHexString()
        }
        return ""
    }
    
    func decrypt() -> String {
        
        let array = Array(hex: self)
        
        if let aes = try? AES(key: "0123456789abcdef", iv: "fedcba9876543210") {
            
            if let decrypt = try? aes.decrypt(array),
                let strBase64 =  String(bytes: decrypt, encoding: .utf8),
                let data = Data(base64Encoded: strBase64)
            {
                return String(data: data, encoding: .utf8) ?? ""
            }
        }
        return ""
    }
    
    var encryptParameter: String {
        guard let aes = try? AES(key: "0123456789abcdef", iv: "fedcba9876543210"),
            let encrypted = try? aes.encrypt(Array(self.utf8)) else { return "" }
        return encrypted.toHexString()
        
    }
    
    var toBase64:String {
        guard let data = self.data(using: String.Encoding.utf8) else { return "" }
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
    
    func insertSeparator(_ separatorString: String, atEvery n: Int) -> String {
        guard 0 < n else { return self }
        return self.enumerated().map({String($0.element) + (($0.offset != self.count - 1 && $0.offset % n ==  n - 1) ? "\(separatorString)" : "")}).joined()
    }

    mutating func insertedSeparator(_ separatorString: String, atEvery n: Int) {
        self = insertSeparator(separatorString, atEvery: n)
    }
    
    
    //--------------------------------------------------
    // MARK:- Functions
    //--------------------------------------------------
    
    // This code will add line spacing for multine string
    // Color is dynamic which are get as function arguments
    func addLineSpacing(fontColor: UIColor, size: CGFloat) -> NSAttributedString {
        
        // Create paragram instance to add line spacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        // Set attribute string for message
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont(name: FontName.MADETOMMY, size: size)!,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor: fontColor
        ]
        
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    //==========================================
    //MARK: - To get Localized String from String
    //==========================================
    
    func localizedString()->String{
        
        return  NSLocalizedString(self, tableName: "Messages", bundle: Bundle.main, value: "", comment: "") as String;
    }
    
    func addLineSpacing(fontName: String, fontColor: UIColor, size: CGFloat, lineSpacing: CGFloat, textAlignment: NSTextAlignment) -> NSAttributedString {
        
        // Create paragram instance to add line spacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = textAlignment
        
        // Set attribute string for message
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont(name: fontName, size: size)!,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor: fontColor
        ]
        
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    func separate(every stride: Int = 4, with separator: Character = " ") -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func timeInterval(timeAgo:String, dateFormatter: String) -> String
    {
        
        let dateWithTime = Date.convertUTCStringToDate(timeAgo, dateFormat: dateFormatter)
        
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second] , from: dateWithTime!, to: Date())
        
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + StringKeys.TimeCalculation.year_ago.localized : "\(year)" + " " + StringKeys.TimeCalculation.years_ago.localized
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + StringKeys.TimeCalculation.month_ago.localized : "\(month)" + " " + StringKeys.TimeCalculation.months_ago.localized
        } else if let day = interval.day, day > 0 {
            if day < 7{
                return day == 1 ? "\(day)" + " " + StringKeys.TimeCalculation.day_ago.localized : "\(day)" + " " + StringKeys.TimeCalculation.days_ago.localized
            }else {
                return "\(Date().weeksFrom(dateWithTime!))" + " " + StringKeys.TimeCalculation.week_ago.localized
            }
        }else if let hour = interval.hour, hour > 0 {
            
            return hour == 1 ? "\(hour)" + " " + StringKeys.TimeCalculation.hour_ago.localized : "\(hour)" + " " + StringKeys.TimeCalculation.hours_ago.localized
            
        }else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "\(minute)" + " " + StringKeys.TimeCalculation.minute_ago.localized : "\(minute)" + " " + StringKeys.TimeCalculation.minutes_ago.localized
        }else if let second = interval.second, second > 0 {
            
            if second <= 15{
                return second == 1 ? StringKeys.TimeCalculation.justnow.localized : "\(second)" + " " + StringKeys.TimeCalculation.seconds_ago.localized
            }else{
                return second == 1 ? "\(second)" + " " + StringKeys.TimeCalculation.second_ago.localized : "\(second)" + " " + StringKeys.TimeCalculation.seconds_ago.localized
            }
            
        } else {
            return StringKeys.TimeCalculation.a_moment_ago.localized
        }
    }
}


/*
extension Array {
    
    public func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key:Element] {
        var dict = [Key:Element]()
        for element in self {
            dict[selectKey(element)] = element
        }
        return dict
    }
    
    var encryptArrayOfDictionary:String {
        let dataObject = NSKeyedArchiver.archivedData(withRootObject: self)
        guard let aes = try? AES(key: "0123456789abcdef", iv: "fedcba9876543210"),
            let encrypted = try? aes.encrypt(dataObject.bytes) else { return "" }
        return encrypted.toHexString()
    }
    
    var toBase64:String {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
    
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func printJson() {
        print(json)
    }
}

*/

extension Double {
    
    func valueWithDollar() -> String {
        return String(format: "$%.2f", self)
    }
    
    /// Rounds the double to decimal places value
    func roundTo(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

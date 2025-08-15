//
//  UITextField.swift
//  Pharma247
//
//  Created by Sagar Chauhan on 21/08/19.
//  Copyright © 2019 TRooTech. All rights reserved.
//

import Foundation
import UIKit


private var AssociatedObjectHandle: UInt8 = 0

extension UITextField {
    
    //--------------------------------------------------
    // MARK:- Variables
    //--------------------------------------------------
    
    var isEmpty: Bool {
        get {
            if self.text == nil {
                return true
            }
            return self.text!.isEmpty
        }
    }
    
    var isPasteEnable: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as? Bool ?? true
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    //--------------------------------------------------
    // MARK:- Methods
    //--------------------------------------------------
    
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
            return isPasteEnable
        }
        
        return true
    }
    
    //--------------------------------------------------
    
    func trim() -> String {
        return self.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    
    //--------------------------------------------------
    
    func addLeftViewForPadding(width: CGFloat) {
        let uiView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        self.leftViewMode = .always
        self.leftView = uiView
    }
    
    //--------------------------------------------------
    
    func addRightMandotaryView() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: self.frame.height))
        label.text = " * "
        label.textColor = .red
        self.rightViewMode = .always
        self.rightView = label
    }
    
    //--------------------------------------------------
    
    func setGrayBorder() {
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
}



enum CardType: String {
    case Unknown, Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay
    
    static let allCards = [Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay]
    
    var regex : String {
        switch self {
        case .Amex:
            return "^3[47][0-9]{5,}$"
        case .Visa:
            return "^4[0-9]{6,}([0-9]{3})?$"
        case .MasterCard:
            return "^(5[1-5][0-9]{4}|677189)[0-9]{5,}$"
        case .Diners:
            return "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        case .Discover:
            return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        case .JCB:
            return "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
        case .UnionPay:
            return "^(62|88)[0-9]{5,}$"
        case .Hipercard:
            return "^(606282|3841)[0-9]{5,}$"
        case .Elo:
            return "^((((636368)|(438935)|(504175)|(451416)|(636297))[0-9]{0,10})|((5067)|(4576)|(4011))[0-9]{0,12})$"
        default:
            return ""
        }
    }
}


extension UITextField{
    
    func validateCreditCardFormat()-> (type: CardType, valid: Bool) {
        // Get only numbers from the input string
        let input = self.text!
        let numberOnly = input.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        //        let numberOnly = input.stringByReplacingOccurrencesOfString("[^0-9]", withString: "", options: .RegularExpressionSearch)
        
        var type: CardType = .Unknown
        var formatted = ""
        var valid = false
        
        // detect card type
        for card in CardType.allCards {
            if (matchesRegex(regex: card.regex, text: numberOnly)) {
                type = card
                break
            }
        }
        
        // check validity
        valid = luhnCheck(number: numberOnly)
        
        // format
        var formatted4 = ""
        for character in numberOnly {
            if formatted4.count == 4 {
                formatted += formatted4 + " "
                formatted4 = ""
            }
            formatted4.append(character)
        }
        
        formatted += formatted4 // the rest
        
        // return the tuple
        return (type, valid)
    }
    
    func matchesRegex(regex: String!, text: String!) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            let nsString = text as NSString
            let match = regex.firstMatch(in: text, options: [], range: NSMakeRange(0, nsString.length))
            return (match != nil)
        } catch {
            return false
        }
    }
    
    func luhnCheck(number: String) -> Bool {
        var sum = 0
        let digitStrings = number.reversed().map { String($0) }
        
        for tuple in digitStrings.enumerated() {
            guard let digit = Int(tuple.element) else { return false }
            let odd = tuple.offset % 2 == 1
            
            switch (odd, digit) {
            case (true, 9):
                sum += 9
            case (true, 0...8):
                sum += (digit * 2) % 9
            default:
                sum += digit
            }
        }
        
        return sum % 10 == 0
    }
}

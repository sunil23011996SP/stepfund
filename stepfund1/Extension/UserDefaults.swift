//
//  UserDefaults.swift
//  Pharma247
//
//  Created by Sagar Chauhan on 26/08/19.
//  Copyright © 2019 TRooTech. All rights reserved.
//

import Foundation

// Create Namespace protocol
protocol KeyNamespaceable { }


// Extends KeyNamespaceable protocol
extension KeyNamespaceable {
    
    /**
     A simple function that does some string interpolation that combines two objects and separates them with a full stop; the name of the class, and the rawValue of they key.\
     We also relied on generics to allow our function take in a generic type for the key arguement if it conforms to RawRepresentable.
     */
    static func namespace<T>(_ key: T) -> String where T: RawRepresentable {
        return "\(Self.self).\(key.rawValue)"
    }
}


// Create BoolUserDefaultable which extends KeyNamespaceable
// This will stored only bool values
protocol BoolUserDefaultable: KeyNamespaceable {
    associatedtype BoolDefaultKey: RawRepresentable
}


// Extends BoolUserDefaultable to set and get bool value from it
extension BoolUserDefaultable where BoolDefaultKey.RawValue == String {
    
    // Stores value inside UserDefaults
    static func set(_ value: Bool, forKey key: BoolDefaultKey) {
        let key = namespace(key)
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    // Get value from UserDefaults
    static func bool(forKey key: BoolDefaultKey) -> Bool {
        let key = namespace(key)
        return UserDefaults.standard.bool(forKey: key)
    }
}


// This will stored only string values
protocol StringUserDefaultable: KeyNamespaceable {
    associatedtype StringDefaultKey: RawRepresentable
}


// Extends BoolUserDefaultable to set and get bool value from it
extension StringUserDefaultable where StringDefaultKey.RawValue == String {
    
    // Stores value inside UserDefaults
    static func set(_ value: String, forKey key: StringDefaultKey) {
        let key = namespace(key)
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    // Get value from UserDefaults
    static func string(forKey key: StringDefaultKey) -> String {
        let key = namespace(key)
        return UserDefaults.standard.string(forKey: key) ?? ""
    }
}

protocol AnyUserDefaultable: KeyNamespaceable {
    associatedtype AnyDefaultKey: RawRepresentable
}

extension AnyUserDefaultable where AnyDefaultKey.RawValue == String {
    
    // Stores value inside UserDefaults
    static func set(_ value: Any, forKey key: AnyDefaultKey) {
        let key = namespace(key)
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    // Get value from UserDefaults
    static func object(forKey key: AnyDefaultKey) -> Any {
        let key = namespace(key)
        return UserDefaults.standard.object(forKey: key) ?? ""
    }
}



// Create extension of UserDefaults which have structure related to data and that contains keys relative to data
extension UserDefaults {
    
    // Create Account Structure
    struct Account: BoolUserDefaultable {
        enum BoolDefaultKey: String {
            case isUserLoggedIn
        }
    }
    
    struct UserInfo: AnyUserDefaultable {
        enum AnyDefaultKey: String {
            case signupData
            case loginData
        }
    }
    
    // Create Application Structure
    struct Application: BoolUserDefaultable {
        enum BoolDefaultKey: String {
            case isAppOpenAgain
            case isPointPopupOpenFirstTime
            case isPointPaymentEnable
        }
    }
    
    struct Tokens: StringUserDefaultable {
        enum StringDefaultKey: String {
            case authToken
            case deviceToken
            case apnsToken
        }
    }
    
    struct UserData: StringUserDefaultable {
        enum StringDefaultKey: String {
            case userId
            case firstName
            case lastName
            case contact
            case email
            case dob
            case gender
            case favoriteLocation
            case maritalStatus
            case isChildren
            case numberOfChild
            case address
            case age
            case barcode
            case createdAt
            case barcodeImage
            case favoriteLocationName
            case wallet
            case loyaltyPoints
            case loyaltyStatus
            case userPoints
        }
    }
    
    struct StoreData: AnyUserDefaultable {
        enum AnyDefaultKey: String {
            case selectedStore
            case pointPayment
            case storeCartCount
        }
    }
}

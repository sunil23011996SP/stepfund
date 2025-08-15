//
//  UserSetting.swift
//  stepfund1
//
//  Created by satish prajapati on 03/08/25.
//

import Foundation


enum UserDefaultKey: String {
    case userID
    case subscription
    case user
    case fcmToken = "FcmToken"
    case versionNumber = "versionNumber"
    case aws
    case token
    case accessToken
}
let defaults = UserDefaults.standard

enum UserDefaultAWSKey: String {
    case bucketName, bucketSecretKey, bucketKey, region
}

struct UserDefaultsSettings {
    
    
    static func storeUserPrefrences(_ data: LoginDataResModel?) {
        UserDefaultsSettings.user = data
    }
    
    static var acessToken: String? {
        get {
            return defaults.string(forKey: "accessToken")
        } set {
            if let newValue = newValue, !newValue.isEmpty {
                defaults.set(newValue, forKey: "accessToken")
            } else {
                defaults.removeObject(forKey: "accessToken")
            }
        }
    }
    
    
    static var user: LoginDataResModel? {
        get {
            return getValue(fromKey: .user)
        }set {
            storeValue(newValue, inKey: .user)
        }
    }
 
    
    static func clearDefaultData() {
        self.acessToken = ""
        defaults.removeObject(forKey: "accessToken")
        defaults.removeObject(forKey: "isLoggedIn")
        defaults.removeObject(forKey: "aws_access_key")
        defaults.removeObject(forKey: "aws_secret_key")
        defaults.removeObject(forKey: "aws_bucket_name")
        defaults.removeObject(forKey: UserDefaultKey.user.rawValue)
    }
    
    static func storeUserPrefrences(_ response1: LoginResModel? = nil) {
       
        guard let data = response1?.data else { return }
            UserDefaultsSettings.user = data
                    
            if let token = data.token {
                UserDefaultsSettings.acessToken = token
            }
    }
    
    private static func storeValue<T: Codable>(_ value: T?, inKey key: UserDefaultKey) {
        if (value == nil) {
            defaults.set(nil, forKey: key.rawValue)
            return
        }
        
        guard
            let data = try? JSONEncoder().encode(value!),
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
            else {
                return
        }
        defaults.set(jsonObject, forKey: key.rawValue)
    }
    
    private static func getValue<T: Codable>(fromKey key: UserDefaultKey) -> T? {
        guard
            let jsonData = defaults.value(forKey: key.rawValue),
            let data = try? JSONSerialization.data(withJSONObject: jsonData, options: [])
            else {
                return nil
        }
        return try? JSONDecoder().decode(T.self
            , from: data)
    }
    
    
}


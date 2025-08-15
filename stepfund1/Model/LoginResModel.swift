//
//  LoginResModel.swift
//  stepfund1
//
//  Created by satish prajapati on 03/08/25.
//

import Foundation
import ObjectMapper


// MARK: - Welcome

struct LoginResModel: Codable {
    let code, message: String?
    let data: LoginDataResModel?
}

// MARK: - DataClass
struct LoginDataResModel: Codable {
    let id: Int?
    let fullname, countryCode, phone, email: String?
    let password: String?
    let profileImage: String?
    let latitude, longitude, percentage, earning: String?
    let login, lastLogin, referralCode: String?
    let referralID: Int
    let referralEaning, isReferralEarning, status, insertdate: String?
    let updatetime, token, language, deviceID: String?
    let deviceType, bankName, accountNumber, accountHolderName: String?
    let ibanNumber: String?
    let isSubscription: Int?
    let subscriptionName, isKyc: String?
    let encToken: String?

    enum CodingKeys: String, CodingKey {
        case id, fullname
        case countryCode = "country_code"
        case phone, email, password
        case profileImage = "profile_image"
        case latitude, longitude, percentage, earning, login
        case lastLogin = "last_login"
        case referralCode = "referral_code"
        case referralID = "referral_id"
        case referralEaning = "referral_eaning"
        case isReferralEarning = "is_referral_earning"
        case status, insertdate, updatetime, token, language
        case deviceID = "device_id"
        case deviceType = "device_type"
        case bankName = "bank_name"
        case accountNumber = "account_number"
        case accountHolderName = "account_holder_name"
        case ibanNumber = "iban_number"
        case isSubscription = "is_subscription"
        case subscriptionName = "subscription_name"
        case isKyc = "is_kyc"
        case encToken
    }
}


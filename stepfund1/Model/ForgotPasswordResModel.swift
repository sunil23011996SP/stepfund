//
//  ForgotPasswordResModel.swift
//  stepfund1
//
//  Created by satish prajapati on 03/08/25.
//

import Foundation
import ObjectMapper

struct forgotpasswordResModel: Codable {
    let code, message: String
    let data: forgotpasswordDataResModel?
}

// MARK: - DataClass
struct forgotpasswordDataResModel: Codable {
    let token, otp: String
}


struct sendEmailResModel: Codable {
    let code, message: String
    let data: sendEmailDataResModel?
}

// MARK: - DataClass
struct sendEmailDataResModel: Codable {
    let otp: Int
}

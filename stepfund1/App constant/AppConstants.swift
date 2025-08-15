//
//  AppConstants.swift
//  Unido
//
//  Created by Sagar Chauhan on 16/10/19.
//  Copyright © 2019 TRooTech. All rights reserved.
//

import Foundation
import UIKit

var IsIphoneX:Bool = false
var IsIphone5:Bool = false
var SelectTruckTypeName = ""
var SelectLoadTypeName = ""


// MARK- General Keys
struct AppConstant {
    static let appName    =  Bundle.main.infoDictionary!["CFBundleName"] as! String
    static let appLink    =  ""
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
}

// MARK- Font Name
struct FontName {
    static let GALOSTEXT_BLACK            = "GolosText-Black"
    static let GALOSTEXT_BOLD             = "GolosText-Bold"
    static let GALOSTEXT_EXTRABOLD        = "GolosText-ExtraBold"
    static let GALOSTEXT_MEDIUM           = "GolosText-Medium"
    static let GALOSTEXT_REGULAR          = "GolosText-Regular"
    static let GALOSTEXT_SEMIBOLD         = "GolosText-SemiBold"
}

//MARK- Colors
struct AppColors{
    
    //Brand Color
    public static let BrandColor = UIColor(named: "BrandColor")
    
    
    //Text Color
    public static let TextColor1 = UIColor(named: "TextColor1")
    
    
}







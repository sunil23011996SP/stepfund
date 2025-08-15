//
//  AppDelegate.swift
//  stepfund1
//
//  Created by satish prajapati on 21/07/25.
//

import UIKit
import SVProgressHUD
import IQKeyboardManagerSwift
import AWSCore
import AWSS3

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window          : UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        setupSVProgressHUD()
                
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func setupSVProgressHUD() {
        SVProgressHUD.setForegroundColor(AppColors.BrandColor!)
        SVProgressHUD.setRingThickness(6.0)
        SVProgressHUD.setBackgroundColor(.clear)
        SVProgressHUD.setDefaultMaskType(.clear)
//        SVProgressHUD.setForegroundColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3))
    }


}

var appUser : LoginResModel?


final class AppData: NSObject {
    
    static let shared = AppData()
    
    static let deviceId = "esP8IP0AQmyo3jHwz_3nLU:APA91bGygGY9aaHZ_sTLgwKUSwH-xJefGGudIqtGaVJrv2fN9AdSKAi25U0EgmGxss0gw4mcxS-4zJ2fjquUx_x8GvbIWSvEc5B2vShyt-Xt_XGE7voSWco"
    
    
    // Hide show loader
    class func ShowProgress(){
        SVProgressHUD.show()
    }
    
    class func HideProgress(){
        SVProgressHUD.dismiss()
    }
    
    
    
    //set multiple Color in one label
    class func setLabelMultipleColor(firstText: String, secondText: String,firstColor:UIColor,secondColor:UIColor) -> NSAttributedString{
        let string = firstText + secondText as NSString
        let result = NSMutableAttributedString(string: string as String)
        
        let attributesForFirstWord = [NSAttributedString.Key.foregroundColor:firstColor as UIColor]
        let attributesForSecondWord = [NSAttributedString.Key.foregroundColor:secondColor as UIColor]
        result.setAttributes(attributesForFirstWord,
                             range: string.range(of: firstText))
        result.setAttributes(attributesForSecondWord,
                             range: string.range(of: secondText))
        return NSAttributedString(attributedString: result)
    }
    
    //==========================================
    //MARK: - Helper Methods
    //==========================================
    
    func saveModel(_ model : AnyObject, forKey key : String) {
        let encodedObject = NSKeyedArchiver.archivedData(withRootObject: model)
        UserDefaults.standard.set(encodedObject, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func getModelForKey(_ key : String) -> AnyObject? {
        
        let encodedObject = UserDefaults.standard.object(forKey: key) as? Data
        let savedModel = encodedObject != nil ? NSKeyedUnarchiver.unarchiveObject(with: encodedObject!) : nil
        return savedModel as AnyObject?
    }
    
    func removeModelForKey(_ key : String) {
        
        UserDefaults.standard.removeObject(forKey: key)
        
        UserDefaults.standard.synchronize()
        //appUser = nil
    }
}


struct UserDefaultsKey {
    static let user_key                                 = "UserKey"
    static let userName                                 = "UserName"
    static let authToken                                = "authToken"
    static let UserProfile                              = "UserProfile"
    static let UserMobileNumber                         = "UserMobileNumber"
    static let UserCountryCode                          = "UserCountryCode"
    static let mobileNo                                 = "mobileNo"
    static let countryCode                              = "countryCode"
    static let DEVICE_UDID                              = "DEVICE_UDID"
}

//
//  Alertview.swift
//  stepfund1
//
//  Created by satish prajapati on 02/08/25.
//

import Foundation
import UIKit

var AppName:String = "STEPFUND"
typealias buttonClicked = (NSInteger) -> Void

class AlertAction : UIAlertAction{
    var  tag : NSInteger?
}


class AlertView: NSObject {
    
    static let sharedInstance = AlertView()
    fileprivate override init() {} //This prevents others from using the default '()' initializer for
    
    var alertController : UIAlertController?
    
    class func showOKTitleAlert(_ strTitle : String, viewcontroller : UIViewController){
        
        AlertView.showAlert(strTitle, strMessage: "", button: NSMutableArray(object: ok()),viewcontroller : viewcontroller, blockButtonClicked: nil)
    }
    
    class func showOKMessageAlert(_ strMessage : String, viewcontroller : UIViewController){
        
        AlertView.showAlert(AppName, strMessage: strMessage, button:  NSMutableArray(object: ok()),viewcontroller : viewcontroller, blockButtonClicked: nil)
    }
    
    class func showMessageAlert(_ strMessage : String, viewcontroller : UIViewController){
        
        AlertView.showAlert("", strMessage: strMessage, button:  NSMutableArray(object: ok()),viewcontroller : viewcontroller, blockButtonClicked: nil)
    }
    
    class func showOKTitleMessageAlert(_ strTitle : String,strMessage : String, viewcontroller : UIViewController){
        
        AlertView.showAlert(strTitle, strMessage: strMessage, button:  NSMutableArray(object: ok()),viewcontroller : viewcontroller, blockButtonClicked: nil)
    }
    
    class func showAlert(_ strTitle : String,strMessage : String,button:NSMutableArray, viewcontroller : UIViewController, blockButtonClicked : buttonClicked?){
        
        print(strTitle);
        let alert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: UIAlertController.Style.alert);
        alert.view.tintColor = UIColor.init(named: "007dd6")
        for i in 0  ..< button.count {
            
            let str = button.object(at: i) as? String;
            let action = AlertAction(title: str, style: UIAlertAction.Style.default) { (a) -> Void in
                
                blockButtonClicked?((a as! AlertAction).tag!)
            }
            
            action.tag = i
            alert.addAction(action);
        }
        
        viewcontroller.present(alert, animated: true) { () -> Void in
        }
    }
    
    class func ok() -> String{
        return "OK"
    }
    
}

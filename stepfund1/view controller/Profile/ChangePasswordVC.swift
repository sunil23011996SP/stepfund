//
//  ChangePasswordVC.swift
//  stepfund1
//
//  Created by satish prajapati on 04/08/25.
//

import UIKit

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var labelChangePassword: UILabel!
    @IBOutlet weak var labelSetstrong: UILabel!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtResetPassword: UITextField!
    @IBOutlet weak var btnshowOldPassword: UIButton!
    @IBOutlet weak var btnshowNewPassword: UIButton!
    @IBOutlet weak var btnshowResetPassword: UIButton!

    var showoldpassword = true
    var shownewpassword = true
    var showresetpassword = true
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelChangePassword.font = UIFont(name: "GolosText-SemiBold", size: 16)
        labelSetstrong.font = UIFont(name: "GolosText-Regular", size: 14)
        btnUpdate.titleLabel?.font =  UIFont(name: "GolosText-SemiBold", size: 16)
        txtOldPassword.font = UIFont(name: "GolosText-Regular", size: 14)

        txtNewPassword.font = UIFont(name: "GolosText-Regular", size: 14)
        txtResetPassword.font = UIFont(name: "GolosText-Regular", size: 14)
        
        txtOldPassword.attributedPlaceholder = NSAttributedString(
            string: "Old Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )
        txtNewPassword.attributedPlaceholder = NSAttributedString(
            string: "New Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )
        txtResetPassword.attributedPlaceholder = NSAttributedString(
            string: "Reset Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )
    }
    
    //--------------------------------------------------
    // MARK:- Abstract Method
    //--------------------------------------------------
    class func viewController() -> ChangePasswordVC {
        return UIStoryboard.main.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
    }
    
    //--------------------------------------------------
    // MARK:- Button Action
    //--------------------------------------------------
    @IBAction func btnSubmitClikced(_ sender: UIButton) {
        if validate() {
            self.postEncryptionAPI()
        }
    }
    @IBAction func btnOldPasswordClicked(sender: AnyObject) {
        if showoldpassword {
            txtOldPassword.isSecureTextEntry = false
            btnshowOldPassword.setImage(UIImage(named: "showpassword"), for: .normal)
            
        } else {
            txtOldPassword.isSecureTextEntry = true
            btnshowOldPassword.setImage(UIImage(named: "passwordHide"), for: .normal)
        }
        showoldpassword = !showoldpassword
    }
    @IBAction func btnShowNewPasswordClicked(sender: AnyObject) {
        if shownewpassword {
            txtNewPassword.isSecureTextEntry = false
            btnshowNewPassword.setImage(UIImage(named: "showpassword"), for: .normal)
            
        } else {
            txtNewPassword.isSecureTextEntry = true
            btnshowNewPassword.setImage(UIImage(named: "passwordHide"), for: .normal)
        }
        shownewpassword = !shownewpassword
    }
    @IBAction func btnShowResetPasswordClicked(sender: AnyObject) {
        if showresetpassword {
            txtResetPassword.isSecureTextEntry = false
            btnshowResetPassword.setImage(UIImage(named: "showpassword"), for: .normal)
            
        } else {
            txtResetPassword.isSecureTextEntry = true
            btnshowResetPassword.setImage(UIImage(named: "passwordHide"), for: .normal)
        }
        showresetpassword = !showresetpassword
    }
    
   
    @IBAction func backButtonClikced(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK: - Validation Check
extension ChangePasswordVC {
    func validate() -> Bool
    {
        if txtOldPassword.text!.isEmpty {
            AlertView.showOKTitleAlert("Please enter old password", viewcontroller: self)
            return false
        }
        
        if txtNewPassword.text!.isEmpty {
            AlertView.showOKTitleAlert("Please enter new password", viewcontroller: self)
            return false
        }
        
        if txtResetPassword.text!.isEmpty {
            AlertView.showOKTitleAlert("Please enter reset password", viewcontroller: self)
            return false
        }
        if txtNewPassword.text! !=  txtResetPassword.text!{
            AlertView.showOKTitleAlert("Your new password and reset password do not match.", viewcontroller: self)
            return false
        }
        
        return true
        
    }
}
//MARK:- API calling
extension ChangePasswordVC{
    
    func postEncryptionAPI(){
        AppData.ShowProgress()
        
        
        let parameters = "{ \"old_password\": \"\(txtOldPassword.text ?? "")\", \"new_password\": \"\(txtNewPassword.text ?? "")\" }"
            
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: DataManager.shared.getURL(.getEncryption))!,timeoutInterval: Double.infinity)
        request.addValue("Gemflb3MR+S7AcOvPSfNSA==", forHTTPHeaderField: "api-key")
        request.addValue("en", forHTTPHeaderField: "accept-language")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
            self.postChangePasswordAPI(envalue: String(data: data, encoding: .utf8)!)
        }

        task.resume()

    }
    
    func postChangePasswordAPI(envalue:String){

        let postData = envalue.data(using: .utf8)

        var request = URLRequest(url: URL(string: DataManager.shared.getURL(.changePassword))!,timeoutInterval: Double.infinity)
        request.addValue("Gemflb3MR+S7AcOvPSfNSA==", forHTTPHeaderField: "api-key")
        request.addValue("en", forHTTPHeaderField: "accept-language")
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.addValue(UserDefaultsSettings.user?.encToken ?? "", forHTTPHeaderField: "token")


        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
        
            self.postDecryptionAPI(resEncValue: String(data: data, encoding: .utf8)!)
        }

        task.resume()

    }
    
    func postDecryptionAPI(resEncValue:String){
                
        let postData = resEncValue.data(using: .utf8)

        var request = URLRequest(url: URL(string: DataManager.shared.getURL(.getDecryption))!,timeoutInterval: Double.infinity)
        request.addValue("Gemflb3MR+S7AcOvPSfNSA==", forHTTPHeaderField: "api-key")
        request.addValue("en", forHTTPHeaderField: "accept-language")
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            do {
                if let data = data {
                    let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    let decoder = JSONDecoder()
                        if let jsonData = try? decoder.decode(CommonResponse.self, from: data) {
                        print("response",jsonData)
                        AppData.HideProgress()
                        if jsonData.code == "1" {
                            AlertView.showOKTitleAlert(jsonData.message ?? "", viewcontroller: self)
                            self.txtOldPassword.text = ""
                            self.txtNewPassword.text = ""
                            self.txtResetPassword.text = ""
                        }else{
                            AlertView.showOKTitleAlert(jsonData.message ?? "", viewcontroller: self)
                        }
                    }
                    
                }
            } catch {
                print("error")
            }
        }
        task.resume()

    }
    
}


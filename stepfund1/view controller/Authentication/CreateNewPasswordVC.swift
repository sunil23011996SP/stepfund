//
//  CreateNewPasswordVC.swift
//  stepfund1
//
//  Created by satish prajapati on 03/08/25.
//

import UIKit

class CreateNewPasswordVC: UIViewController {

    @IBOutlet weak var labelCreate: UILabel!
    @IBOutlet weak var labelSetstrong: UILabel!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtResetPassword: UITextField!
    @IBOutlet weak var btnshowNewPassword: UIButton!
    @IBOutlet weak var btnshowResetPassword: UIButton!

    @IBOutlet weak var viewpopupMain: UIView!
    @IBOutlet weak var viewpopup: UIView!
    @IBOutlet weak var labelSuccess: UILabel!
    @IBOutlet weak var labelyourpassword: UILabel!
    @IBOutlet weak var btnBacktoLogin: UIButton!

    var shownewpassword = true
    var showresetpassword = true
    var token = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelCreate.font =  UIFont(name: "GolosText-SemiBold", size: 26)
        labelSetstrong.font = UIFont(name: "GolosText-Regular", size: 14)
        btnUpdate.titleLabel?.font =  UIFont(name: "GolosText-SemiBold", size: 16)
        txtNewPassword.font = UIFont(name: "GolosText-Regular", size: 14)
        txtResetPassword.font = UIFont(name: "GolosText-Regular", size: 14)
        labelSuccess.font =  UIFont(name: "GolosText-SemiBold", size: 26)
        labelyourpassword.font = UIFont(name: "GolosText-Regular", size: 14)
        btnBacktoLogin.titleLabel?.font =  UIFont(name: "GolosText-SemiBold", size: 16)

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
    class func viewController() -> CreateNewPasswordVC {
        return UIStoryboard.main.instantiateViewController(withIdentifier: "CreateNewPasswordVC") as! CreateNewPasswordVC
    }
    
    //--------------------------------------------------
    // MARK:- Button Action
    //--------------------------------------------------
    @IBAction func btnSubmitClikced(_ sender: UIButton) {
        if validate() {
            if Reachability.isConnectedToNetwork(){
                self.postEncryptionAPI(email: txtNewPassword.text ?? "")
            }else{
                AlertView.showOKTitleAlert(AppConstant.noInternetConnection, viewcontroller: self)
            }
            
        }
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
    @IBAction func btnBacktoLoginClicked(_ sender: UIButton) {
        
        self.navigationController?.popToViewController(LoginViewController.viewController(), animated: true)
    }
}
//MARK: - Validation Check
extension CreateNewPasswordVC {
    func validate() -> Bool
    {
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
extension CreateNewPasswordVC{
    
    func postEncryptionAPI(email:String){
        AppData.ShowProgress()
        
        let parameters = "{ \"new_password\": \"\(email)\" }"
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
            self.postForgotPasswordAPI(envalue: String(data: data, encoding: .utf8)!)
        }

        task.resume()

    }
    
    func postForgotPasswordAPI(envalue:String){

        let postData = envalue.data(using: .utf8)

        var request = URLRequest(url: URL(string: DataManager.shared.getURL(.resetPassword))!,timeoutInterval: Double.infinity)
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
                        
                    }
                    
                }
            } catch {
                print("error")
            }
        }
        task.resume()

    }
    
}


struct CommonResponse: Codable {
    var code: String?
    var message: String?
}




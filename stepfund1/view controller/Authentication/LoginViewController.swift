//
//  LoginViewController.swift
//  stepfund1
//
//  Created by satish prajapati on 21/07/25.
//

import UIKit


class LoginViewController: UIViewController {

    @IBOutlet weak var labelReadyto: UILabel!
    @IBOutlet weak var labellogin: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnshowPassword: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var labeldonthave: UILabel!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtpassword: UITextField!

    
    var shownewpassword = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        IQKeyboardManager.shared.isEnabled = true
//        IQKeyboardManager.shared.enableAutoToolbar = true

        
        labelReadyto.font =  UIFont(name: "GolosText-SemiBold", size: 26)
        labellogin.font = UIFont(name: "GolosText-Regular", size: 14)
        btnLogin.titleLabel?.font =  UIFont(name: "GolosText-SemiBold", size: 16)
        txtEmail.font = UIFont(name: "GolosText-Regular", size: 14)
        txtpassword.font = UIFont(name: "GolosText-Regular", size: 14)
        btnForgotPassword.titleLabel?.font =  UIFont(name: "GolosText-Regular", size: 16)
        labeldonthave.font = UIFont(name: "GolosText-Regular", size: 14)
        btnSignup.titleLabel?.font =  UIFont(name: "GolosText-Bold", size: 14)

        
        txtEmail.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )
        txtpassword.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )
    }
    
    //--------------------------------------------------
    // MARK:- Abstract Method
    //--------------------------------------------------
    class func viewController() -> LoginViewController {
        return UIStoryboard.main.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    }
    
    //--------------------------------------------------
    // MARK:- Button Action
    //--------------------------------------------------
    
    @IBAction func btnLoginClikced(_ sender: UIButton) {
        if validate() {
            if Reachability.isConnectedToNetwork(){
                self.postEncryptionAPI()
            }else{
                AlertView.showOKTitleAlert(AppConstant.noInternetConnection, viewcontroller: self)
            }
           
        }
    }
    
    @IBAction func btnShowNewPasswordClicked(sender: AnyObject) {
        if shownewpassword {
            txtpassword.isSecureTextEntry = false
            btnshowPassword.setImage(UIImage(named: "showpassword"), for: .normal)
            
        } else {
            txtpassword.isSecureTextEntry = true
            btnshowPassword.setImage(UIImage(named: "passwordHide"), for: .normal)
        }
        shownewpassword = !shownewpassword
    }
    @IBAction func btnSignupClicked(_ sender: UIButton) {
        let vc = SignUpViewController.viewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnForgotPasswordClicked(_ sender: UIButton) {
        let vc = ForgotPasswordViewController.viewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - Validation Check
extension LoginViewController {
    func validate() -> Bool
    {
        if txtEmail.text!.isEmpty {
            if !Validation().isEmailValidate(testStr: txtEmail.text!){
                AlertView.showOKTitleAlert("Please enter valid email address", viewcontroller: self)
                return false
            }
            AlertView.showOKTitleAlert("Please enter email address", viewcontroller: self)
            return false
        }
        if txtpassword.text!.isEmpty {
            AlertView.showOKTitleAlert("Please enter password", viewcontroller: self)
            return false
        }
        
        return true
        
    }
}
//MARK:- API calling
extension LoginViewController{
    
    func postEncryptionAPI(){
        AppData.ShowProgress()
        
        let parameters = "{ \"email\": \"\(txtEmail.text ?? "")\",\"password\": \"\(txtpassword.text ?? "")\", \"device_type\": \"I\", \"device_id\": \"\(AppData.deviceId)\" }"
        
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
            self.postLoginAPI(envalue: String(data: data, encoding: .utf8)!)
        }

        task.resume()

    }
    
    func postLoginAPI(envalue:String){

        let postData = envalue.data(using: .utf8)

        var request = URLRequest(url: URL(string: DataManager.shared.getURL(.login))!,timeoutInterval: Double.infinity)
        request.addValue("Gemflb3MR+S7AcOvPSfNSA==", forHTTPHeaderField: "api-key")
        request.addValue("en", forHTTPHeaderField: "accept-language")
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")

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
                    DispatchQueue.main.async {
                        let decoder = JSONDecoder()
                        if let jsonData = try? decoder.decode(LoginResModel.self, from: data) {
                            print("response",jsonData)
                            if jsonData.code == "1" {
                                UserDefaultsSettings.storeUserPrefrences(jsonData.data)
                                UserDefaultsSettings.acessToken = jsonData.data?.token ?? ""
                                
                                print("token",jsonData.data?.encToken ?? "")
                                UserDefaults.standard.set(true, forKey: "isLoggedIn")

                                let vc = HomeViewController.viewController()
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            else{
                                AlertView.showOKTitleAlert(jsonData.message ?? "", viewcontroller: self)
                                
                            }
                            AppData.HideProgress()
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


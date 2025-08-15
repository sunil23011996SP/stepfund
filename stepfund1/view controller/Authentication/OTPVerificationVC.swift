//
//  OTPVerificationVC.swift
//  stepfund1
//
//  Created by satish prajapati on 21/07/25.
//

import UIKit


class OTPVerificationVC: UIViewController {

    @IBOutlet weak var labelotpverification: UILabel!
    @IBOutlet weak var labelwellsend: UILabel!
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var txtOtpfieldview: OTPFieldView!
    @IBOutlet weak var labeldidntget: UILabel!
    @IBOutlet weak var btnResendOtp: UIButton!
    @IBOutlet weak var viewResendOTP: UIView!
    @IBOutlet weak var lblOTPTimer: UILabel!

    @IBOutlet weak var viewpopupMain: UIView!
    @IBOutlet weak var viewpopup: UIView!
    @IBOutlet weak var labelYouAreIn: UILabel!
    @IBOutlet weak var labelyourAccount: UILabel!
    @IBOutlet weak var btnExporeApp: UIButton!
    
    var fromSignUpVC : Bool = true
    var otp = ""
    var token = ""
    var fullname = ""
    var email = ""
    var countryCode = ""
    var phoneno = ""
    var password = ""
    var referalcode = ""
    var enteredOTP = ""
    
    var seconds = 30
    var timer = Timer()
    var isTimerRunning = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelotpverification.font =  UIFont(name: "GolosText-SemiBold", size: 26)
        labelwellsend.font = UIFont(name: "GolosText-Regular", size: 14)
        btnVerify.titleLabel?.font =  UIFont(name: "GolosText-SemiBold", size: 16)
        labeldidntget.font = UIFont(name: "GolosText-Regular", size: 14)
        btnResendOtp.titleLabel?.font =  UIFont(name: "GolosText-Medium.ttf", size: 16)
        
        labelYouAreIn.font =  UIFont(name: "GolosText-SemiBold", size: 26)
        labelyourAccount.font = UIFont(name: "GolosText-Regular", size: 14)
        btnExporeApp.titleLabel?.font =  UIFont(name: "GolosText-SemiBold", size: 16)

        
        self.txtOtpfieldview.fieldsCount = 4
        self.txtOtpfieldview.fieldBorderWidth = 1
        self.txtOtpfieldview.defaultBorderColor = UIColor.white.withAlphaComponent(0.3)
        self.txtOtpfieldview.filledBorderColor = UIColor.init(hex: "0059FF")
        self.txtOtpfieldview.cursorColor = UIColor.white
        self.txtOtpfieldview.displayType = .roundedCorner
        self.txtOtpfieldview.fieldSize = 50
        self.txtOtpfieldview.separatorSpace = 12
        self.txtOtpfieldview.shouldAllowIntermediateEditing = false
        self.txtOtpfieldview.delegate = self
        self.txtOtpfieldview.initializeUI()
        
        self.seconds = 30
        self.runTimer()
        self.lblOTPTimer.isHidden = false
        self.viewResendOTP.isHidden = true

    }
    
    //--------------------------------------------------
    // MARK:- Abstract Method
    //--------------------------------------------------
    class func viewController() -> OTPVerificationVC {
        return UIStoryboard.main.instantiateViewController(withIdentifier: "OTPVerificationVC") as! OTPVerificationVC
    }
    
    //--------------------------------------------------
    // MARK:- Button Action
    //--------------------------------------------------
    
    @IBAction func btnVerifyClikced(_ sender: UIButton) {
        if enteredOTP == ""{
            AlertView.showOKTitleAlert("Please enter verification code", viewcontroller: self)
        }
        else if enteredOTP != otp{
            AlertView.showOKTitleAlert("Please enter valid code", viewcontroller: self)
        }
        else if enteredOTP == otp{
            
            if fromSignUpVC == true{
                postSignupEncryptionAPI()
            }else{
                let vc = CreateNewPasswordVC.viewController()
                vc.token = token
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    
    @IBAction func btnResendOTPClikced(_ sender: UIButton) {
        self.sendEmailEncryptionAPI(email: email)
    }
    
    @IBAction func backButtonClikced(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnExploreAppClicked(_ sender: UIButton) {
        let vc = HomeViewController.viewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension OTPVerificationVC: OTPFieldViewDelegate {
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        return false
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp otpString: String) {
        print("OTPString: \(otpString)")
        enteredOTP = otpString
    }
}

//MARK:- API calling
extension OTPVerificationVC{
    
    func sendEmailEncryptionAPI(email:String){
        AppData.ShowProgress()
        
        let parameters = "{ \"email\": \"\(email)\" }"
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
            self.postsendEmailAPI(envalue: String(data: data, encoding: .utf8)!)
        }

        task.resume()

    }
    
    func postsendEmailAPI(envalue:String){

        let postData = envalue.data(using: .utf8)

        var request = URLRequest(url: URL(string: DataManager.shared.getURL(.sendEmail))!,timeoutInterval: Double.infinity)
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
            self.sendEmailDecryptionAPI(resEncValue: String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func sendEmailDecryptionAPI(resEncValue:String){
                
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
                        if let jsonData = try? decoder.decode(sendEmailResModel.self, from: data) {
                            print("response",jsonData)
                            if jsonData.code == "4" {
                                self.seconds = 30
                                self.runTimer()
                                self.lblOTPTimer.isHidden = false
                                self.viewResendOTP.isHidden = true
                                self.otp = "\(jsonData.data?.otp ?? 0)"
                                AlertView.showOKTitleAlert(jsonData.message, viewcontroller: self)
                            }else{
                                AlertView.showOKTitleAlert(jsonData.message, viewcontroller: self)
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
    
    func postSignupEncryptionAPI(){
        AppData.ShowProgress()
        
        let parameters = "{\"fullname\":\"\(fullname)\",\"email\": \"\(email)\",\"country_code\": \"\(countryCode)\",\"phone\":\"\(phoneno)\",\"password\":\"\(password)\",\"device_type\":\"I\",\"device_id\": \"\(AppData.deviceId)\"}"
        
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
            self.postSignupAPI(envalue: String(data: data, encoding: .utf8)!)
        }

        task.resume()

    }
    
    func postSignupAPI(envalue:String){
        let postData = envalue.data(using: .utf8)

        var request = URLRequest(url: URL(string: DataManager.shared.getURL(.signup))!,timeoutInterval: Double.infinity)
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
            self.postSignupDecryptionAPI(resEncValue: String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func postSignupDecryptionAPI(resEncValue:String){
                
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
                                
                                self.viewpopupMain.isHidden = false
                                self.viewpopup.isHidden = false
                                UserDefaults.standard.set(true, forKey: "isLoggedIn")

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

//-------------------------------------------------------//
//MARK:- Timer Function
//-------------------------------------------------------//
extension OTPVerificationVC{
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
    }
    @objc func updateTimer() {
        if seconds == 0 {
            timer.invalidate()
            self.viewResendOTP.isHidden = false
            self.lblOTPTimer.isHidden = true
        } else {
            seconds -= 1
            lblOTPTimer.text = timeString(time: TimeInterval(seconds))
        }
    }
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i",minutes, seconds)
    }
}


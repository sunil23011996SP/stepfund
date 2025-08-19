//
//  SignUpViewController.swift
//  stepfund1
//
//  Created by satish prajapati on 11/08/25.
//

import UIKit
import CountryPickerView


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var labelCreateYour: UILabel!
    @IBOutlet weak var labelJoinBy: UILabel!
    @IBOutlet weak var labelByClicking: UILabel!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnShowPassword: UIButton!
    @IBOutlet weak var txtConfrimPassword: UITextField!
    @IBOutlet weak var btnShowConfirmPassword: UIButton!
    @IBOutlet weak var txtReferalCode: UITextField!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var txtCountrtCode: CountryPickerView!
    @IBOutlet weak var btnCheckPrivacyPolicy: UIButton!

    var showPasswsord = true
    var showConfirmPassword = true
    var selectPrivacyPolicy = true

    var strCountryCode = ""
    var selectedCountryShortCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelCreateYour.font =  UIFont(name: "GolosText-SemiBold", size: 26)
        labelJoinBy.font = UIFont(name: "GolosText-Regular", size: 14)
        txtFullName.font = UIFont(name: "GolosText-Regular", size: 14)
        txtEmail.font = UIFont(name: "GolosText-Regular", size: 14)
        txtPassword.font = UIFont(name: "GolosText-Regular", size: 14)
        txtConfrimPassword.font = UIFont(name: "GolosText-Regular", size: 14)
        txtMobileNumber.font = UIFont(name: "GolosText-Regular", size: 14)
        txtReferalCode.font = UIFont(name: "GolosText-Regular", size: 14)
        btnCreate.titleLabel?.font =  UIFont(name: "GolosText-Bold", size: 14)
        labelByClicking.font = UIFont(name: "GolosText-Regular", size: 14)

        txtFullName.attributedPlaceholder = NSAttributedString(
            string: "Fullname",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )
        txtEmail.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )
        txtPassword.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )
        txtConfrimPassword.attributedPlaceholder = NSAttributedString(
            string: "Confirm Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )
        txtMobileNumber.attributedPlaceholder = NSAttributedString(
            string: "Mobile Number",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )
        txtReferalCode.attributedPlaceholder = NSAttributedString(
            string: "Referral Code(Optional)",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )
        
        txtCountrtCode.countryDetailsLabel.textAlignment = .center
        txtCountrtCode.font = UIFont(name: "GolosText-Regular", size: 14)!
        txtCountrtCode.textColor = UIColor.white
        txtCountrtCode.showCountryCodeInView = false
        txtCountrtCode.showCountryNameInView = false
        txtCountrtCode.showPhoneCodeInView = true
        txtCountrtCode.dataSource = self
        txtCountrtCode.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        strCountryCode = txtCountrtCode.countryDetailsLabel.text ?? ""
        
        setupMultipleTapLabel()
        self.view.endEditing(true)
    }
    
    //--------------------------------------------------
    // MARK:- Abstract Method
    //--------------------------------------------------
    class func viewController() -> SignUpViewController {
        return UIStoryboard.main.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
    }
    
    @IBAction func btnUpdateClikced(_ sender: UIButton) {
        if validate() {
            if Reachability.isConnectedToNetwork(){
                self.postEncryptionAPI()
            }else{
                AlertView.showOKTitleAlert(AppConstant.noInternetConnection, viewcontroller: self)
            }
        }
    }
    
    @IBAction func btnPasswordClicked(sender: AnyObject) {
        if showPasswsord {
            txtPassword.isSecureTextEntry = false
            btnShowPassword.setImage(UIImage(named: "showpassword"), for: .normal)
            
        } else {
            txtPassword.isSecureTextEntry = true
            btnShowPassword.setImage(UIImage(named: "passwordHide"), for: .normal)
        }
        showPasswsord = !showPasswsord
    }
    
    @IBAction func btnConfirmPasswordClicked(sender: AnyObject) {
        if showConfirmPassword {
            txtConfrimPassword.isSecureTextEntry = false
            btnShowConfirmPassword.setImage(UIImage(named: "showpassword"), for: .normal)
        } else {
            txtConfrimPassword.isSecureTextEntry = true
            btnShowConfirmPassword.setImage(UIImage(named: "passwordHide"), for: .normal)
        }
        showConfirmPassword = !showConfirmPassword
    }
    
    @IBAction func btnbackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAcceptPrivacyClicked(sender: AnyObject) {
        if selectPrivacyPolicy {
            btnCheckPrivacyPolicy.setImage(UIImage(named: "check_Selected"), for: .normal)
        } else {
            btnCheckPrivacyPolicy.setImage(UIImage(named: "check_Unselected"), for: .normal)
        }
        selectPrivacyPolicy = !selectPrivacyPolicy
    }
    
}


extension SignUpViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        let title = "Selected Country"
        let message = "Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)"
        
        selectedCountryShortCode = country.code
        strCountryCode = country.phoneCode
        
    }
}
extension SignUpViewController: CountryPickerViewDataSource {
    //    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
    //        return "Select a Country"
    //    }
    //
    
    func closeButtonNavigationItem(in countryPickerView: CountryPickerView) -> UIBarButtonItem? {
        return nil
    }
    
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return countryPickerView.tag == txtCountrtCode.tag
    }
    
    func showCountryCodeInList(in countryPickerView: CountryPickerView) -> Bool {
       return countryPickerView.tag == txtCountrtCode.tag
    }
}



//MARK: - Validation Check
extension SignUpViewController {
    func validate() -> Bool
    {
        if txtFullName.text!.isEmpty {
            AlertView.showOKTitleAlert("Please enter fullname.", viewcontroller: self)
            return false
        }
        if txtEmail.text!.isEmpty {
            if !Validation().isEmailValidate(testStr: txtEmail.text!){
                AlertView.showOKTitleAlert("Please enter valid email address", viewcontroller: self)
                return false
            }
            AlertView.showOKTitleAlert("Please enter email address", viewcontroller: self)
            return false
        }
        if txtPassword.text!.isEmpty {
            AlertView.showOKTitleAlert("Please enter password", viewcontroller: self)
            return false
        }
        if txtConfrimPassword.text!.isEmpty {
            AlertView.showOKTitleAlert("Please enter confirm password", viewcontroller: self)
            return false
        }
        if txtPassword.text! !=  txtConfrimPassword.text!{
            AlertView.showOKTitleAlert("Your password and confirm password do not match.", viewcontroller: self)
            return false
        }
        if txtMobileNumber.text!.isEmpty {
            AlertView.showOKTitleAlert("Please enter mobile number", viewcontroller: self)
            return false
        }
        if txtMobileNumber.text!.isEmpty {
            AlertView.showOKTitleAlert("Please enter mobile number", viewcontroller: self)
            return false
        }
        return true
        
    }
}

//MARK: - setup clickable label
extension SignUpViewController {

    func setupMultipleTapLabel() {
           labelByClicking.text = "By continuing, you agree to the Terms of Service and Privacy Policy."
           let text = (labelByClicking.text)!
           let underlineAttriString = NSMutableAttributedString(string: text)
           let termsRange = (text as NSString).range(of: "Terms of Service")
           let privacyRange = (text as NSString).range(of: "Privacy Policy.")
           underlineAttriString.addAttribute(.foregroundColor, value: UIColor.blue, range: termsRange)
           underlineAttriString.addAttribute(.foregroundColor, value: UIColor.blue, range: privacyRange)
           
        labelByClicking.attributedText = underlineAttriString
           let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(gesture:)))
        labelByClicking.isUserInteractionEnabled = true
        labelByClicking.lineBreakMode = .byCharWrapping

        labelByClicking.addGestureRecognizer(tapAction)


       }

   @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
           if gesture.didTapAttributedTextInLabel(label: labelByClicking, targetText: "Terms of Service") {
               print("Terms of service")
               let vc = TermsAndConditionVC.viewController()
               self.navigationController?.pushViewController(vc, animated: true)
               
           } else if gesture.didTapAttributedTextInLabel(label: labelByClicking, targetText: "Privacy Policy.") {
               print("Privacy policy")
               let vc = PrivacyPolicyVC.viewController()
               self.navigationController?.pushViewController(vc, animated: true)
           } else {
               print("Tapped none")
           }
   }
}
    

//MARK:- API calling
extension SignUpViewController{
    
    func postEncryptionAPI(){
        AppData.ShowProgress()
        
        let parameters = "{ \"email\":\"\(txtEmail.text ?? "")\",\"country_code\":\"\(strCountryCode)\",\"phone\":\"\(txtMobileNumber.text ?? "")\"}"
        
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
            self.postCheckDuplicationAPI(envalue: String(data: data, encoding: .utf8)!)
        }

        task.resume()

    }
    
    func postCheckDuplicationAPI(envalue:String){
        let postData = envalue.data(using: .utf8)

        var request = URLRequest(url: URL(string: DataManager.shared.getURL(.checkDuplication))!,timeoutInterval: Double.infinity)
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
                        if let jsonData = try? decoder.decode(checkDuplicateResModel.self, from: data) {
                            print("response",jsonData)
                            if jsonData.code == "1" {
                                self.sendEmailEncryptionAPI()
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
    
    func sendEmailEncryptionAPI(){
        AppData.ShowProgress()
        
        let parameters = "{\"email\":\"\(self.txtEmail.text ?? "")\"}"
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
                                
                                let vc = OTPVerificationVC.viewController()
                                vc.otp = "\(jsonData.data?.otp ?? 0)"
                                vc.fullname = self.txtFullName.text ?? ""
                                vc.email = self.txtEmail.text ?? ""
                                vc.countryCode = self.strCountryCode
                                vc.phoneno = self.txtMobileNumber.text ?? ""
                                vc.referalcode = self.txtReferalCode.text ?? ""
                                vc.password = self.txtPassword.text ?? ""
                                vc.fromSignUpVC = true
                                self.navigationController?.pushViewController(vc, animated: true)
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
}

struct checkDuplicateResModel: Codable {
    let code, message: String?
}

extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, targetText: String) -> Bool {
        guard let attributedString = label.attributedText, let lblText = label.text else { return false }
        let targetRange = (lblText as NSString).range(of: targetText)
        //IMPORTANT label correct font for NSTextStorage needed
        let mutableAttribString = NSMutableAttributedString(attributedString: attributedString)
        mutableAttribString.addAttributes(
            [NSAttributedString.Key.font: label.font ?? UIFont.smallSystemFontSize],
            range: NSRange(location: 0, length: attributedString.length)
        )
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: mutableAttribString)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y:
            locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}

//
//  ContctUsViewController.swift
//  stepfund1
//
//  Created by satish prajapati on 05/08/25.
//

import UIKit

class ContctUsViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var labelContactUs: UILabel!
    @IBOutlet weak var labelGetInTouchWith: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtSubject: UITextField!
    @IBOutlet weak var txtViewMessage: UITextView!
    @IBOutlet weak var labelMessagePlaceholder: UILabel!

    
    var strFullName = ""
    var strEmail = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelContactUs.font = UIFont(name: "GolosText-SemiBold", size: 16)
        labelGetInTouchWith.font = UIFont(name: "GolosText-Regular", size: 14)
        btnSubmit.titleLabel?.font =  UIFont(name: "GolosText-SemiBold", size: 16)
        txtFullName.font = UIFont(name: "GolosText-Regular", size: 14)
        txtEmail.font = UIFont(name: "GolosText-Regular", size: 14)
        txtSubject.font = UIFont(name: "GolosText-Regular", size: 14)
        txtViewMessage.font = UIFont(name: "GolosText-Regular", size: 14)
        
        txtFullName.attributedPlaceholder = NSAttributedString(
            string: "Bank Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )
        txtEmail.attributedPlaceholder = NSAttributedString(
            string: "Account Number",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )
        txtSubject.attributedPlaceholder = NSAttributedString(
            string: "Confirm Account Number",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )
        txtFullName.text = strFullName
        txtEmail.text = strEmail
    }
    
    //--------------------------------------------------
    // MARK:- Abstract Method
    //--------------------------------------------------
    class func viewController() -> ContctUsViewController {
        return UIStoryboard.main.instantiateViewController(withIdentifier: "ContctUsViewController") as! ContctUsViewController
    }
    
    //--------------------------------------------------
    // MARK:- Button Action
    //--------------------------------------------------
    @IBAction func btnSubmitClikced(_ sender: UIButton) {
        if validate() {
            if Reachability.isConnectedToNetwork(){
                self.postEncryptionAPI()
            }else{
                AlertView.showOKTitleAlert(AppConstant.noInternetConnection, viewcontroller: self)
            }
        }
    }
   
    @IBAction func backButtonClikced(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {     labelMessagePlaceholder.isHidden = true
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trim == "" {
            labelMessagePlaceholder.isHidden = false
        } else {
            labelMessagePlaceholder.isHidden = true
        }
    }
}
//MARK: - Validation Check
extension ContctUsViewController {
    func validate() -> Bool
    {
        if txtSubject.text!.isEmpty {
            AlertView.showOKTitleAlert("Please enter subject", viewcontroller: self)
            return false
        }
        
        if txtViewMessage.text!.isEmpty {
            AlertView.showOKTitleAlert("Please enter message", viewcontroller: self)
            return false
        }
        return true
        
    }
}
//MARK:- API calling
extension ContctUsViewController{
    
    func postEncryptionAPI(){
        AppData.ShowProgress()
                
        let parameters = "{ \"fullname\":\"\(txtFullName.text ?? "")\",\"subject\": \"\(txtSubject.text ?? "")\", \"email\": \"\(txtEmail.text ?? "")\", \"message\":\"\(txtViewMessage.text ?? "")\" }"
            
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
            self.postContactUSAPI(envalue: String(data: data, encoding: .utf8)!)
        }

        task.resume()

    }
    
    func postContactUSAPI(envalue:String){

        let postData = envalue.data(using: .utf8)

        var request = URLRequest(url: URL(string: DataManager.shared.getURL(.contactUs))!,timeoutInterval: Double.infinity)
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
                    let decoder = JSONDecoder()
                        if let jsonData = try? decoder.decode(ContactUsResModel.self, from: data) {
                            
                            AppData.HideProgress()
                        print("response",jsonData)
                            DispatchQueue.main.async {
                                if jsonData.code == "1"{
                                    AlertView.showAlert(jsonData.message ?? "", strMessage: "", button: ["OK"], viewcontroller: self) { (btn) in
                                        if btn == 0 {
                                            self.navigationController?.popViewController(animated: true)
                                        }
                                        else{
                                            self.dismiss(animated: true, completion: nil)
                                        }
                                    }
                                }
                                else if jsonData.code == "-1"{
                                    AppData.HideProgress()
                                    AlertView.showAlert(jsonData.message ?? "", strMessage: "", button: ["OK"], viewcontroller: self) { (btn) in
                                        if btn == 0 {
                                            let vc = LoginViewController.viewController()
                                            UserDefaultsSettings.clearDefaultData()
                                            self.navigationController?.pushViewController(vc, animated: true)
                                        }
                                    }
                                }
                                else{
                                    AlertView.showOKTitleAlert(jsonData.message ?? "", viewcontroller: self)
                                }
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


struct ContactUsResModel: Codable {
    var code: String?
    var message: String?
}

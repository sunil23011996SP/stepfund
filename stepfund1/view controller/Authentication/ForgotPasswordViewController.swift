//
//  ForgotPasswordViewController.swift
//  stepfund1
//
//  Created by satish prajapati on 21/07/25.
//

import UIKit


class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var labelforgot: UILabel!
    @IBOutlet weak var labelwellsend: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelwellsend.font = UIFont(name: "GolosText-Regular", size: 14)
        labelforgot.font =  UIFont(name: "GolosText-SemiBold", size: 26)
        btnSubmit.titleLabel?.font =  UIFont(name: "GolosText-SemiBold", size: 16)
        txtEmail.font = UIFont(name: "GolosText-Regular", size: 14)
        
        txtEmail.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )
    }
    
    //--------------------------------------------------
    // MARK:- Abstract Method
    //--------------------------------------------------
    class func viewController() -> ForgotPasswordViewController {
        return UIStoryboard.main.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
    }
    
    //--------------------------------------------------
    // MARK:- Button Action
    //--------------------------------------------------
    
    @IBAction func btnSubmitClikced(_ sender: UIButton) {
        if validate() {
            self.postEncryptionAPI(email: txtEmail.text ?? "")
        }
    }
    
   
    @IBAction func backButtonClikced(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: - Validation Check
extension ForgotPasswordViewController {
    func validate() -> Bool
    {
        if txtEmail.text!.isEmpty {
            AlertView.showOKTitleAlert("Please enter email address", viewcontroller: self)
            return false
        }
        
        return true
        
    }
}
//MARK:- API calling
extension ForgotPasswordViewController{
    
    func postEncryptionAPI(email:String){
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
            self.postForgotPasswordAPI(envalue: String(data: data, encoding: .utf8)!)
        }

        task.resume()

    }
    
    func postForgotPasswordAPI(envalue:String){

        let postData = envalue.data(using: .utf8)

        var request = URLRequest(url: URL(string: DataManager.shared.getURL(.forgotPassword))!,timeoutInterval: Double.infinity)
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
                        if let jsonData = try? decoder.decode(forgotpasswordResModel.self, from: data) {
                            print("response",jsonData)
                            if jsonData.code == "1" {
                                AlertView.showAlert(jsonData.message, strMessage: "", button: ["OK"], viewcontroller: self) { (btn) in
                                    if btn == 0 {
                                        let vc = OTPVerificationVC.viewController()
                                        vc.token = jsonData.data?.token ?? ""
                                        vc.otp = jsonData.data?.otp ?? ""
                                        vc.email = self.txtEmail.text ?? ""
                                        vc.fromSignUpVC = false
                                        self.navigationController?.pushViewController(vc, animated: true)
                                        
                                    }
                                    else{
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                }
                                
                                
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

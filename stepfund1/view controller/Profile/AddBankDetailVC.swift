//
//  AddBankDetailVC.swift
//  stepfund1
//
//  Created by satish prajapati on 04/08/25.
//

import UIKit

class AddBankDetailVC: UIViewController {

    @IBOutlet weak var labelBankDetails: UILabel!
    @IBOutlet weak var labelAddYour: UILabel!
    @IBOutlet weak var btnUpdate: UIButton!
    
    @IBOutlet weak var txtBankName: UITextField!
    @IBOutlet weak var txtAccountNo: UITextField!
    @IBOutlet weak var txtCAccountNo: UITextField!
    @IBOutlet weak var txtAcHodlerName: UITextField!
    @IBOutlet weak var txtIBANno: UITextField!
    
    var bankname = ""
    var accountNo = ""
    var accountHolderName = ""
    var ibanNo = ""

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelBankDetails.font = UIFont(name: "GolosText-SemiBold", size: 16)
        labelAddYour.font = UIFont(name: "GolosText-Regular", size: 14)
        btnUpdate.titleLabel?.font =  UIFont(name: "GolosText-SemiBold", size: 16)
        txtBankName.font = UIFont(name: "GolosText-Regular", size: 14)
        txtAccountNo.font = UIFont(name: "GolosText-Regular", size: 14)
        txtCAccountNo.font = UIFont(name: "GolosText-Regular", size: 14)
        txtAcHodlerName.font = UIFont(name: "GolosText-Regular", size: 14)
        txtIBANno.font = UIFont(name: "GolosText-Regular", size: 14)
        
        txtBankName.attributedPlaceholder = NSAttributedString(
            string: "Bank Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )
        txtAccountNo.attributedPlaceholder = NSAttributedString(
            string: "Account Number",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )
        txtCAccountNo.attributedPlaceholder = NSAttributedString(
            string: "Confirm Account Number",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )
        txtAcHodlerName.attributedPlaceholder = NSAttributedString(
            string: "Account Holder Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )
        txtIBANno.attributedPlaceholder = NSAttributedString(
            string: "IBAN Number",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )
        
        txtBankName.text = bankname
        txtAccountNo.text = accountNo
        txtCAccountNo.text = accountNo
        txtAcHodlerName.text = accountHolderName
        txtIBANno.text = ibanNo
    }
    
    //--------------------------------------------------
    // MARK:- Abstract Method
    //--------------------------------------------------
    class func viewController() -> AddBankDetailVC {
        return UIStoryboard.main.instantiateViewController(withIdentifier: "AddBankDetailVC") as! AddBankDetailVC
    }
    
    //--------------------------------------------------
    // MARK:- Button Action
    //--------------------------------------------------
    @IBAction func btnSubmitClikced(_ sender: UIButton) {
        if validate() {
            self.postEncryptionAPI()
        }
    }
   
    @IBAction func backButtonClikced(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: - Validation Check
extension AddBankDetailVC {
    func validate() -> Bool
    {
        if txtBankName.text!.isEmpty {
            AlertView.showOKTitleAlert("Please enter bank name", viewcontroller: self)
            return false
        }
        
        if txtAccountNo.text!.isEmpty {
            AlertView.showOKTitleAlert("Please enter account number", viewcontroller: self)
            return false
        }
        
        if txtCAccountNo.text!.isEmpty {
            AlertView.showOKTitleAlert("Please enter confirm account number", viewcontroller: self)
            return false
        }
        if txtAccountNo.text! !=  txtCAccountNo.text!{
            AlertView.showOKTitleAlert("Your account number and confrim account number do not match.", viewcontroller: self)
            return false
        }
        
        if txtAcHodlerName.text!.isEmpty {
            AlertView.showOKTitleAlert("Please enter account holder", viewcontroller: self)
            return false
        }
        if txtIBANno.text!.isEmpty {
            AlertView.showOKTitleAlert("Please enter IBAN number", viewcontroller: self)
            return false
        }
        
        return true
        
    }
}
//MARK:- API calling
extension AddBankDetailVC{
    
    func postEncryptionAPI(){
        AppData.ShowProgress()
        
        let parameters = "{\"bank_name\":\"\(txtBankName.text ?? "")\",\"account_number\":\"\(txtAccountNo.text ?? "")\",\"account_holder_name\":\"\(txtAcHodlerName.text ?? "")\",\"iban_number\":\"\(txtIBANno.text ?? "")\"}"
            
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
            self.postAddBankDetailAPI(envalue: String(data: data, encoding: .utf8)!)
        }

        task.resume()

    }
    
    func postAddBankDetailAPI(envalue:String){

        let postData = envalue.data(using: .utf8)

        var request = URLRequest(url: URL(string: DataManager.shared.getURL(.addUpdateBank))!,timeoutInterval: Double.infinity)
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
                        if let jsonData = try? decoder.decode(AddBankDetailsResModel.self, from: data) {
                            
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

struct AddBankDetailsResModel: Codable {
    var code: String?
    var message: String?
}

//
//  TermsAndConditionVC.swift
//  stepfund1
//
//  Created by satish prajapati on 03/08/25.
//

import UIKit
import WebKit

class TermsAndConditionVC: UIViewController {

    @IBOutlet weak var viewtermsCondition: WKWebView!
    @IBOutlet weak var labelTermsCondtion: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        labelTermsCondtion.font = UIFont(name: "GolosText-SemiBold", size: 16)

        postTermsConditionAPI()
        
        // Do any additional setup after loading the view.
    }
    
    func increaseFontSize() {
           let jsString = """
           var style = document.createElement('style');
           style.innerHTML = 'body { font-size: 150% !important; }';
           document.head.appendChild(style);
           """
        viewtermsCondition.evaluateJavaScript(jsString, completionHandler: nil)
    }
    
    class func viewController() -> TermsAndConditionVC {
        return UIStoryboard.main.instantiateViewController(withIdentifier: "TermsAndConditionVC") as! TermsAndConditionVC
    }
        
    @IBAction func btnBack(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK:- API calling
extension TermsAndConditionVC{
   
   func postTermsConditionAPI(){

       AppData.ShowProgress()

       var request = URLRequest(url: URL(string: "http://44.204.4.225/home/terms_conditions")!,timeoutInterval: Double.infinity)
       request.addValue("Gemflb3MR+S7AcOvPSfNSA==", forHTTPHeaderField: "api-key")
       request.addValue("ci_session=5gmq94r616ekhbfot4247bl76usshq30", forHTTPHeaderField: "Cookie")

       request.httpMethod = "POST"

       let task = URLSession.shared.dataTask(with: request) { data, response, error in
         guard let data = data else {
           print(String(describing: error))
           return
         }
         print(String(data: data, encoding: .utf8)!)
           AppData.HideProgress()
           DispatchQueue.main.async {
               DispatchQueue.main.asyncAfter(deadline: .now()) {
                   self.increaseFontSize()
               }
               self.viewtermsCondition.loadHTMLString(String(data: data, encoding: .utf8)!, baseURL: nil)
           }
       }

       task.resume()

   }
   
}


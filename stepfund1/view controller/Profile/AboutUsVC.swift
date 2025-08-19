//
//  AboutUsVC.swift
//  stepfund1
//
//  Created by satish prajapati on 03/08/25.
//

import UIKit
import WebKit

class AboutUsVC: UIViewController {

   
    @IBOutlet weak var viewAboutUs: WKWebView!
    @IBOutlet weak var labelAboutUs: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        labelAboutUs.font = UIFont(name: "GolosText-SemiBold", size: 16)
        if Reachability.isConnectedToNetwork(){
            postAboutUsAPI()
        }else{
            AlertView.showOKTitleAlert(AppConstant.noInternetConnection, viewcontroller: self)
        }
        
    }
    class func viewController() -> AboutUsVC {
        return UIStoryboard.main.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
    }
    @IBAction func btnBack(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- API calling
extension AboutUsVC{
   
   func postAboutUsAPI(){

       AppData.ShowProgress()

       var request = URLRequest(url: URL(string: "http://44.204.4.225/home/about_us")!,timeoutInterval: Double.infinity)
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
               self.viewAboutUs.loadHTMLString(String(data: data, encoding: .utf8)!, baseURL: nil)
           }
       }

       task.resume()

   }
   
}


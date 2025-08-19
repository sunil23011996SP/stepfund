//
//  FAQsViewController.swift
//  stepfund1
//
//  Created by satish prajapati on 03/08/25.
//

import UIKit

class FAQsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tblviewFaqs: UITableView!
    @IBOutlet weak var labelFAQs: UILabel!

        
    var arrFAQsList: [getFAQDataResModel] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelFAQs.font = UIFont(name: "GolosText-SemiBold", size: 16)

        
        let nib = UINib(nibName: "FAQsTableViewCell", bundle: nil)
        tblviewFaqs.register(nib, forCellReuseIdentifier: "FAQsTableViewCell")

        tblviewFaqs.delegate = self
        tblviewFaqs.dataSource = self
        
        if Reachability.isConnectedToNetwork(){
            self.postFAQsAPI()
        }else{
            AlertView.showOKTitleAlert(AppConstant.noInternetConnection, viewcontroller: self)
        }
        
        // Do any additional setup after loading the view.
    }
    
    class func viewController() -> FAQsViewController {
        return UIStoryboard.main.instantiateViewController(withIdentifier: "FAQsViewController") as! FAQsViewController
    }
    
    @IBAction func backButtonClikced(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    //--------------------------------------------------------------------
    // MARK:- Tableview Delegate and datasoruce methods
    //--------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFAQsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQsTableViewCell", for: indexPath) as! FAQsTableViewCell
        
        cell.lblQuestion.font = UIFont(name: "GolosText-Regular", size: 16)
        cell.lblAnswer.font = UIFont(name: "GolosText-Regular", size: 14)

        cell.lblQuestion.text = "\(indexPath.row + 1). \(arrFAQsList[indexPath.row].question)"
        cell.lblAnswer.text = arrFAQsList[indexPath.row].answer
        

        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }


}
//MARK:- API calling
extension FAQsViewController{
    
    func postFAQsAPI(){
        
        AppData.ShowProgress()
        
        var request = URLRequest(url: URL(string: DataManager.shared.getURL(.getFAQ))!,timeoutInterval: Double.infinity)
        request.addValue("Gemflb3MR+S7AcOvPSfNSA==", forHTTPHeaderField: "api-key")
        request.addValue("en", forHTTPHeaderField: "accept-language")
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.addValue(UserDefaultsSettings.user?.encToken ?? "", forHTTPHeaderField: "token")

        request.httpMethod = "POST"

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
                        if let jsonData = try? decoder.decode(getFAQResModel.self, from: data) {
                            print("response",jsonData)
                            if jsonData.code == "1" {
                                
                                DispatchQueue.main.async {
                                    self.arrFAQsList = jsonData.data
                                    self.tblviewFaqs.reloadData()
                                }
                                                
                            }
                            else if jsonData.code == "-1"{
                                AppData.HideProgress()
                                AlertView.showAlert(jsonData.message, strMessage: "", button: ["OK"], viewcontroller: self) { (btn) in
                                    if btn == 0 {
                                        let vc = LoginViewController.viewController()
                                        UserDefaultsSettings.clearDefaultData()
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                }
                            }
                            else{
                                
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

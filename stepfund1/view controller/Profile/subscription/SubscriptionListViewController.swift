//
//  SubscriptionListViewController.swift
//  stepfund1
//
//  Created by satish prajapati on 07/08/25.
//

import UIKit

class SubscriptionListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var labelAddSubscription: UILabel!
    @IBOutlet weak var labelSubscriptionLevels: UILabel!
    @IBOutlet weak var labelChooseYour: UILabel!
    @IBOutlet weak var labelHigherAmounts: UILabel!
    @IBOutlet weak var labelFeature: UILabel!
    @IBOutlet weak var labelTitle1: UILabel!
    @IBOutlet weak var labelDesc1: UILabel!
    @IBOutlet weak var labelTitle2: UILabel!
    @IBOutlet weak var labelDesc2: UILabel!
    @IBOutlet weak var labelTitle3: UILabel!
    @IBOutlet weak var labelDesc3: UILabel!
    @IBOutlet weak var labelTitle4: UILabel!
    @IBOutlet weak var labelDesc4: UILabel!
    @IBOutlet weak var btnSubscribeNow: UIButton!
    
    @IBOutlet weak var tblviewSubscribePlan: UITableView!
    @IBOutlet weak var HeighttblviewSubscribePlan: NSLayoutConstraint!

        
    var arrSubscriptionPlanList: [SubscriptionPlanDataResModel] = []
    var selectedIndex = 0
    var CurrentPlanPrice = ""
    var currentSubscriptionId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()     
        
        labelAddSubscription.font = UIFont(name: "GolosText-SemiBold", size: 16)
        labelSubscriptionLevels.font = UIFont(name: "GolosText-SemiBold", size: 26)
        labelChooseYour.font = UIFont(name: "GolosText-Regular", size: 14)
        labelHigherAmounts.font = UIFont(name: "GolosText-Regular", size: 14)
        labelFeature.font = UIFont(name: "GolosText-SemiBold", size: 16)
        labelTitle1.font = UIFont(name: "GolosText-Medium", size: 16)
        labelDesc1.font = UIFont(name: "GolosText-Regular", size: 12)
        labelTitle2.font = UIFont(name: "GolosText-Medium", size: 16)
        labelDesc2.font = UIFont(name: "GolosText-Regular", size: 12)
        labelTitle3.font = UIFont(name: "GolosText-Medium", size: 16)
        labelDesc3.font = UIFont(name: "GolosText-Regular", size: 12)
        labelTitle4.font = UIFont(name: "GolosText-Medium", size: 16)
        labelDesc4.font = UIFont(name: "GolosText-Regular", size: 12)
        btnSubscribeNow.titleLabel?.font =  UIFont(name: "GolosText-SemiBold", size: 16)
        
        let nib = UINib(nibName: "SubscriptionPlanTableViewCell", bundle: nil)
        tblviewSubscribePlan.register(nib, forCellReuseIdentifier: "SubscriptionPlanTableViewCell")
        tblviewSubscribePlan.delegate = self
        tblviewSubscribePlan.dataSource = self

        postSubscriptionListAPI()
    }
    
    //--------------------------------------------------
    // MARK:- Abstract Method
    //--------------------------------------------------
    class func viewController() -> SubscriptionListViewController {
        return UIStoryboard.home.instantiateViewController(withIdentifier: "SubscriptionListViewController") as! SubscriptionListViewController
    }

    
    //--------------------------------------------------
    // MARK:- Button Action
    //--------------------------------------------------
    @IBAction func btnSubscribeNowClikced(_ sender: UIButton) {
        let vc = AddSubscriptionViewController.viewController()
        vc.strAmount = CurrentPlanPrice
        vc.strSelectedId = currentSubscriptionId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func backButtonClikced(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //--------------------------------------------------------------------
    // MARK:- Tableview Delegate and datasoruce methods
    //--------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSubscriptionPlanList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionPlanTableViewCell", for: indexPath) as! SubscriptionPlanTableViewCell
        
        if indexPath.row == selectedIndex{
            CurrentPlanPrice = arrSubscriptionPlanList[indexPath.row].price
            cell.imgCheckMark.image = UIImage(named: "check_Selected")
            currentSubscriptionId = "\(arrSubscriptionPlanList[indexPath.row].id)"
        }
        else{
            cell.imgCheckMark.image = UIImage(named: "check_Unselected")
        }
        
        cell.lblPlanName.font = UIFont(name: "GolosText-SemiBold", size: 16)
        cell.lblPlanAmount.font = UIFont(name: "GolosText-SemiBold", size: 18)
        cell.lblPlanPercentage.font = UIFont(name: "GolosText-Regular", size: 14)
        cell.lblPlanName.text = arrSubscriptionPlanList[indexPath.row].name
        cell.lblPlanAmount.text = "₹\(arrSubscriptionPlanList[indexPath.row].price)"
        cell.lblPlanPercentage.text = "(\(arrSubscriptionPlanList[indexPath.row].percentage)%)"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.tblviewSubscribePlan.reloadData()
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }


}

//MARK:- API calling
extension SubscriptionListViewController{
    
    func postSubscriptionListAPI(){

        AppData.ShowProgress()
        
        var request = URLRequest(url: URL(string: DataManager.shared.getURL(.getSubscription))!,timeoutInterval: Double.infinity)
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
                        if let jsonData = try? decoder.decode(SubscriptionPlanResModel.self, from: data) {
                            print("response",jsonData)
                            if jsonData.code == "1" {
                                DispatchQueue.main.async {
                                    self.arrSubscriptionPlanList = jsonData.data
                                    self.tblviewSubscribePlan.reloadData()
                                    self.HeighttblviewSubscribePlan.constant = CGFloat(self.arrSubscriptionPlanList.count*97)
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


//Model
class SubscriptionPlanResModel: Codable {
    let code, message: String
    let data: [SubscriptionPlanDataResModel]

    init(code: String, message: String, data: [SubscriptionPlanDataResModel]) {
        self.code = code
        self.message = message
        self.data = data
    }
}

// MARK: - Datum
class SubscriptionPlanDataResModel: Codable {
    let id: Int
    let name, price, status,percentage: String
    

    init(id: Int, name: String, price: String, status: String,percentage: String) {
        self.id = id
        self.name = name
        self.price = price
        self.status = status
        self.percentage = percentage
    }
}


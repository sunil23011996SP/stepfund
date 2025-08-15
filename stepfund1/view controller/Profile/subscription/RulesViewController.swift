//
//  RulesViewController.swift
//  stepfund1
//
//  Created by satish prajapati on 07/08/25.
//

import UIKit

class RulesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblviewRules: UITableView!
    @IBOutlet weak var labelRules: UILabel!

    
    var arrRulesList: [getRulesModel] = [getRulesModel(title: "Accuracy of Information", desc: "Ensure that all the details you provide (such as personal information, KYC documents, and payment details) are accurate and up to date."),getRulesModel(title: "Eligibility for Withdrawals", desc: "Users must complete the KYC process before being eligible to withdraw coins or currency from their wallet."),getRulesModel(title: "Daily Step Tracking", desc: "Steps are counted only when the app is actively tracking. Your total step count resets every 12 A.M. daily."),getRulesModel(title: "Coin Earning Limits", desc: "The number of coins you can earn each day is based on your physical activity. Coin earning may be capped depending on system settings."),getRulesModel(title: "Valid Wallet Details", desc: "Ensure that your wallet details (USDT (TRC 20 only), or bank) are correct. Withdrawals will only be processed to the wallets you’ve provided.")]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelRules.font = UIFont(name: "GolosText-SemiBold", size: 16)

        let nib = UINib(nibName: "FAQsTableViewCell", bundle: nil)
        tblviewRules.register(nib, forCellReuseIdentifier: "FAQsTableViewCell")

        tblviewRules.delegate = self
        tblviewRules.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    class func viewController() -> RulesViewController {
        return UIStoryboard.home.instantiateViewController(withIdentifier: "RulesViewController") as! RulesViewController
    }
    
    @IBAction func backButtonClikced(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    //--------------------------------------------------------------------
    // MARK:- Tableview Delegate and datasoruce methods
    //--------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRulesList.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQsTableViewCell", for: indexPath) as! FAQsTableViewCell
        
        cell.lblQuestion.font = UIFont(name: "GolosText-Regular", size: 16)
        cell.lblAnswer.font = UIFont(name: "GolosText-Regular", size: 14)

        cell.lblQuestion.text = arrRulesList[indexPath.row].title
        cell.lblAnswer.text = arrRulesList[indexPath.row].desc

        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}



class getRulesModel: Codable {
  
    let title, desc: String
   
    init(title: String, desc: String) {
        self.title = title
        self.desc = desc
    }
}

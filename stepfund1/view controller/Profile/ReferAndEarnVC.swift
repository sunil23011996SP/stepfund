//
//  ReferAndEarnVC.swift
//  stepfund1
//
//  Created by satish prajapati on 05/08/25.
//

import UIKit


class ReferAndEarnVC: UIViewController {

    @IBOutlet weak var labelReferEarn: UILabel!
    @IBOutlet weak var labelinviteFriends: UILabel!
    @IBOutlet weak var labelYourReferalCode: UILabel!
    @IBOutlet weak var lblReferalCode: UILabel!
    @IBOutlet weak var labelHowItWorks: UILabel!
    @IBOutlet weak var label1stQuestion: UILabel!
    @IBOutlet weak var label1stAnswer: UILabel!
    @IBOutlet weak var label2ndQuestion: UILabel!
    @IBOutlet weak var label2ndAnswer: UILabel!
    @IBOutlet weak var label3rdQuestion: UILabel!
    @IBOutlet weak var label3rdAnswer: UILabel!
    @IBOutlet weak var btnInviteNow: UIButton!
    @IBOutlet weak var viewRefercode: UIView!

    var invitecode : String = ""
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelReferEarn.font = UIFont(name: "GolosText-SemiBold", size: 26)
        labelinviteFriends.font = UIFont(name: "GolosText-Regular", size: 14)
        labelYourReferalCode.font = UIFont(name: "GolosText-Regular", size: 12)
        lblReferalCode.font = UIFont(name: "GolosText-Bold", size: 16)
        labelHowItWorks.font = UIFont(name: "GolosText-SemiBold", size: 16)
        label1stQuestion.font = UIFont(name: "GolosText-Medium", size: 14)
        label1stAnswer.font = UIFont(name: "GolosText-Regular", size: 14)
        label2ndQuestion.font = UIFont(name: "GolosText-Medium", size: 14)
        label2ndAnswer.font = UIFont(name: "GolosText-Regular", size: 14)
        label3rdQuestion.font = UIFont(name: "GolosText-Medium", size: 14)
        label3rdAnswer.font = UIFont(name: "GolosText-Regular", size: 14)
        
        lblReferalCode.text = invitecode
        
        btnInviteNow.titleLabel?.font =  UIFont(name: "GolosText-SemiBold", size: 16)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewRefercode.addDashedBorder(whichColor: UIColor.white)
        self.view.layoutIfNeeded()
        
    }
    
    //--------------------------------------------------
    // MARK:- Abstract Method
    //--------------------------------------------------
    class func viewController() -> ReferAndEarnVC {
        return UIStoryboard.main.instantiateViewController(withIdentifier: "ReferAndEarnVC") as! ReferAndEarnVC
    }
    
    //--------------------------------------------------
    // MARK:- Button Action
    //--------------------------------------------------
    @IBAction func btnInviteNowClicked(_ sender: UIButton) {
        
        let textToShare = "Hello, 👋 \n Please refer my code to earn more 🎉 \n Referral Code: \(invitecode) \nDownload the Step Fund now."
        
           let urlToShare = URL(string: "https://play.google.com/store/apps/details?id=com.stepfund")!
           
           let activityVC = UIActivityViewController(activityItems: [textToShare, urlToShare], applicationActivities: nil)

           // For iPads, you must set the popoverPresentationController to avoid crashes
           if let popover = activityVC.popoverPresentationController {
               popover.sourceView = self.view
               popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
               popover.permittedArrowDirections = []
           }

           self.present(activityVC, animated: true, completion: nil)
    }
    @IBAction func btnCopyCodeClicked(_ sender: UIButton) {
        
        self.view.makeToast("Text copied to clipboard!")
    }
   
    @IBAction func backButtonClikced(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
    


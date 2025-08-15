//
//  WalletViewController.swift
//  stepfund1
//
//  Created by satish prajapati on 06/08/25.
//

import UIKit

class WalletViewController: UIViewController {

    @IBOutlet weak var labelWallet: UILabel!
    @IBOutlet weak var lblTotalEarnedCoin: UILabel!
    @IBOutlet weak var labelTotalEarnedCoin: UILabel!
    @IBOutlet weak var lblTotalWithdraw: UILabel!
    @IBOutlet weak var labelTotalWithdraw: UILabel!
    @IBOutlet weak var lblTotalAvailable: UILabel!
    @IBOutlet weak var labelTotalAvailable: UILabel!
    @IBOutlet weak var btnRequestWithdrawal: UIButton!
   
    @IBOutlet weak var viewPopupMain: UIView!
    @IBOutlet weak var viewWithdrawCoin: UIView!
    @IBOutlet weak var labelWithdrawCoin: UILabel!
    @IBOutlet weak var labelBeforeyou: UILabel!
    @IBOutlet weak var btnCompleteKYC: UIButton!
    @IBOutlet weak var btnCancelPopup: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelWallet.font = UIFont(name: "GolosText-SemiBold", size: 16)
        lblTotalEarnedCoin.font = UIFont(name: "GolosText-SemiBold", size: 26)
        labelTotalEarnedCoin.font = UIFont(name: "GolosText-Regular", size: 12)
        lblTotalWithdraw.font = UIFont(name: "GolosText-SemiBold", size: 16)
        labelTotalWithdraw.font = UIFont(name: "GolosText-Regular", size: 12)
        lblTotalAvailable.font = UIFont(name: "GolosText-SemiBold", size: 16)
        labelTotalAvailable.font = UIFont(name: "GolosText-Regular", size: 12)

        btnRequestWithdrawal.titleLabel?.font =  UIFont(name: "GolosText-SemiBold", size: 16)
        
        labelWithdrawCoin.font = UIFont(name: "GolosText-SemiBold", size: 26)
        labelBeforeyou.font = UIFont(name: "GolosText-Regular", size: 14)
        btnCompleteKYC.titleLabel?.font =  UIFont(name: "GolosText-SemiBold", size: 16)
        btnCancelPopup.titleLabel?.font =  UIFont(name: "GolosText-Regular", size: 16)

    }
    
    //--------------------------------------------------
    // MARK:- Abstract Method
    //--------------------------------------------------
    class func viewController() -> WalletViewController {
        return UIStoryboard.home.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
    }
    
    //--------------------------------------------------
    // MARK:- Button Action
    //--------------------------------------------------
    @IBAction func btnRequestWithdrawalClikced(_ sender: UIButton) {
        print(UserDefaultsSettings.user?.isKyc ?? "")
        if UserDefaultsSettings.user?.isKyc == "0"{ // false
           viewPopupMain.isHidden = false
           viewWithdrawCoin.isHidden = false
       }
    }
        
    @IBAction func btnCompleteKYCClicked(_ sender: UIButton) {
        viewPopupMain.isHidden = true
        viewWithdrawCoin.isHidden = true
    }
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        viewPopupMain.isHidden = true
        viewWithdrawCoin.isHidden = true
    }
   
    @IBAction func backButtonClikced(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}


//
//  TRC20CryptoVC.swift
//  stepfund1
//
//  Created by satish prajapati on 05/08/25.
//

import UIKit

class TRC20CryptoVC: UIViewController {

    @IBOutlet weak var labelTRC20: UILabel!
    @IBOutlet weak var lblCryptoAmount: UILabel!
    @IBOutlet weak var labelTodaysPrice: UILabel!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var txtCryptoAddress: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTRC20.font = UIFont(name: "GolosText-SemiBold", size: 16)
        lblCryptoAmount.font = UIFont(name: "GolosText-Regular", size: 14)
        labelTodaysPrice.font = UIFont(name: "GolosText-Regular", size: 14)
        txtCryptoAddress.font = UIFont(name: "GolosText-Regular", size: 14)

        btnUpdate.titleLabel?.font =  UIFont(name: "GolosText-SemiBold", size: 16)
        
        
        txtCryptoAddress.attributedPlaceholder = NSAttributedString(
            string: "Crypto Address",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )
    }
    
    //--------------------------------------------------
    // MARK:- Abstract Method
    //--------------------------------------------------
    class func viewController() -> TRC20CryptoVC {
        return UIStoryboard.home.instantiateViewController(withIdentifier: "TRC20CryptoVC") as! TRC20CryptoVC
    }
    
    //--------------------------------------------------
    // MARK:- Button Action
    //--------------------------------------------------
    @IBAction func btnSubmitClikced(_ sender: UIButton) {
        if validate() {
            
        }
    }
   
    @IBAction func backButtonClikced(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: - Validation Check
extension TRC20CryptoVC {
    func validate() -> Bool
    {
        if txtCryptoAddress.text!.isEmpty {
            AlertView.showOKTitleAlert("Please add trc 20 crypto address", viewcontroller: self)
            return false
        }
                
        return true
        
    }
}

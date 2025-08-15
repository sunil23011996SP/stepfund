//
//  ProfileViewController.swift
//  stepfund1
//
//  Created by satish prajapati on 03/08/25.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var labelProfile: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var labeltotalBalance: UILabel!
    @IBOutlet weak var lbltotalBalance: UILabel!
    @IBOutlet weak var btnWithdraw: UIButton!
    
    @IBOutlet weak var lblSubscriptionName: UILabel!
    @IBOutlet weak var labelupgrade: UILabel!
    @IBOutlet weak var lblKycStatus: UILabel!
    @IBOutlet weak var labelRequired: UILabel!
    @IBOutlet weak var viewKYCstatus: UIView!
    @IBOutlet weak var imgKYCstatus: UIImageView!
    
    @IBOutlet weak var labelReferEarn: UILabel!
    @IBOutlet weak var labelInviteFriends: UILabel!

    @IBOutlet weak var labelTRC20Crypto: UILabel!

    @IBOutlet weak var labelBankDetails: UILabel!
    @IBOutlet weak var labelChangePassword: UILabel!
    @IBOutlet weak var labelRateApp: UILabel!
    @IBOutlet weak var labelShareApp: UILabel!
    @IBOutlet weak var labelTermsCondition: UILabel!
    @IBOutlet weak var labelPrivacyPolicy: UILabel!
    @IBOutlet weak var labelFAQs: UILabel!
    @IBOutlet weak var labelAboutUs: UILabel!
    @IBOutlet weak var labelContactUs: UILabel!
    @IBOutlet weak var labelDeleteAccount: UILabel!
    @IBOutlet weak var labelLogout: UILabel!
    
    @IBOutlet weak var viewPopupMain: UIView!
    @IBOutlet weak var viewLogoutPopup: UIView!
    @IBOutlet weak var labelDelelePopup: UILabel!
    @IBOutlet weak var labelAreyouSureDelete: UILabel!
    @IBOutlet weak var btnYesDelete: UIButton!
    @IBOutlet weak var btnNoThanks: UIButton!

    @IBOutlet weak var viewDeletePopup: UIView!
    @IBOutlet weak var labelLogoutAccount: UILabel!
    @IBOutlet weak var labelAreyouSureLogout: UILabel!
    @IBOutlet weak var btnYesLogout: UIButton!
    @IBOutlet weak var btnNoThanksLogout: UIButton!
    
    @IBOutlet weak var viewWithdrawCoinPopup: UIView!
    @IBOutlet weak var labelWithdrawCoin: UILabel!
    @IBOutlet weak var labelBeforeyou: UILabel!
    @IBOutlet weak var btnCompleteKYC: UIButton!
    @IBOutlet weak var btnCancelPopup: UIButton!
    
    
    var objProfiledata: LoginDataResModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupProfileView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.postProfileDetailAPI()
    }
    
    //--------------------------------------------------
    // MARK:- Abstract Method
    //--------------------------------------------------
    class func viewController() -> ProfileViewController {
        return UIStoryboard.main.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
    }
    
    //--------------------------------------------------
    // MARK:- Button Action
    //--------------------------------------------------
    @IBAction func btnEditProfileClicked(_ sender: UIButton) {
        if objProfiledata != nil{
            let vc = EditProfileViewController.viewController()
            vc.strFullname = objProfiledata?.fullname ?? ""
            vc.strEmail = objProfiledata?.email ?? ""
            vc.strCountryCode = objProfiledata?.countryCode ?? ""
            vc.strPhoneno = objProfiledata?.phone ?? ""
            vc.strImage = objProfiledata?.profileImage ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func btnWidhrawalClicked(_ sender: UIButton) {
        if objProfiledata?.isKyc == "1"{ // true
            let vc = WalletViewController.viewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            viewPopupMain.isHidden = false
            viewWithdrawCoinPopup.isHidden = false
        }
    }
    @IBAction func btnBronzeLevalClicked(_ sender: UIButton) {
        let vc = SubscriptionListViewController.viewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnKYCStatucClicked(_ sender: UIButton) {
        if objProfiledata?.isKyc == "0"{ // true
            let vc = VerifyIdentityViewController.viewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if objProfiledata?.isKyc == "2"{
            AlertView.showOKTitleAlert("KYC verification request already submitted.", viewcontroller: self)
        }
    }
    @IBAction func btnTRC20Clicked(_ sender: UIButton) {
        let vc = TRC20CryptoVC.viewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnReferEarnClicked(_ sender: UIButton) {
        if objProfiledata != nil{
            let vc = ReferAndEarnVC.viewController()
            vc.invitecode = objProfiledata?.referralCode ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func btnBankDetailsClicked(_ sender: UIButton) {
        if objProfiledata != nil{
            let vc = AddBankDetailVC.viewController()
            vc.bankname = objProfiledata?.bankName ?? ""
            vc.accountNo = objProfiledata?.accountNumber ?? ""
            vc.accountHolderName = objProfiledata?.accountHolderName ?? ""
            vc.ibanNo = objProfiledata?.ibanNumber ?? ""
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    @IBAction func btnChangePasswordClikced(_ sender: UIButton) {
        let vc = ChangePasswordVC.viewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnRateAppClikced(_ sender: UIButton) {
        if let url = URL(string: "https://www.google.com"){
            UIApplication.shared.open(url)
        }
    }
    @IBAction func btnShareAppClikced(_ sender: UIButton) {
        let textToShare = "Check this out!"
           let urlToShare = URL(string: "https://example.com")!
           
           let activityVC = UIActivityViewController(activityItems: [textToShare, urlToShare], applicationActivities: nil)

           // For iPads, you must set the popoverPresentationController to avoid crashes
           if let popover = activityVC.popoverPresentationController {
               popover.sourceView = self.view
               popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
               popover.permittedArrowDirections = []
           }

           self.present(activityVC, animated: true, completion: nil)
    }
    @IBAction func btnTermsConditionClikced(_ sender: UIButton) {
        let vc = TermsAndConditionVC.viewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnPrivacyPolicyClikced(_ sender: UIButton) {
        let vc = PrivacyPolicyVC.viewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnFAQsClikced(_ sender: UIButton) {
        let vc = FAQsViewController.viewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnAboutUsClikced(_ sender: UIButton) {
        let vc = AboutUsVC.viewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnContactUsClikced(_ sender: UIButton) {
        if objProfiledata != nil{
            let vc = ContctUsViewController.viewController()
            vc.strFullName = objProfiledata?.fullname ?? ""
            vc.strEmail = objProfiledata?.email ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func btnDeleteAccountClikced(_ sender: UIButton) {
        viewPopupMain.isHidden = false
        viewDeletePopup.isHidden = false
    }
    @IBAction func btnLogoutClikced(_ sender: UIButton) {
        viewPopupMain.isHidden = false
        viewLogoutPopup.isHidden = false
    }
    @IBAction func backButtonClikced(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnYesDeleteAccountClikced(_ sender: UIButton) {
        viewPopupMain.isHidden = true
        viewDeletePopup.isHidden = true
    }
    @IBAction func btnYesLogoutAccountClikced(_ sender: UIButton) {
        viewPopupMain.isHidden = true
        viewLogoutPopup.isHidden = true
    }
    @IBAction func btnNoThanksDeleteClikced(_ sender: UIButton) {
        viewPopupMain.isHidden = true
        viewDeletePopup.isHidden = true
    }
    @IBAction func btnNoThanksLogoutClikced(_ sender: UIButton) {
        viewPopupMain.isHidden = true
        viewLogoutPopup.isHidden = true
    }
    
    @IBAction func btnCompleteKYCClicked(_ sender: UIButton) {
        viewPopupMain.isHidden = true
        viewWithdrawCoinPopup.isHidden = true

        if objProfiledata?.isKyc == "0"{ // true
            let vc = VerifyIdentityViewController.viewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if objProfiledata?.isKyc == "2"{
            AlertView.showOKTitleAlert("KYC verification request already submitted.", viewcontroller: self)
        }
    }
    
    @IBAction func btnCancelClicked(_ sender: UIButton) {
        viewPopupMain.isHidden = true
        viewWithdrawCoinPopup.isHidden = true
    }
    
    func SetupProfileView(){
        labelProfile.font = UIFont(name: "GolosText-SemiBold", size: 16)

        lblUsername.font = UIFont(name: "GolosText-Medium", size: 22)
        btnEditProfile.titleLabel?.font =  UIFont(name: "GolosText-Medium", size: 12)
        btnWithdraw.titleLabel?.font =  UIFont(name: "GolosText-Medium", size: 12)

        lbltotalBalance.font = UIFont(name: "GolosText-SemiBold", size: 16)
        lblSubscriptionName.font = UIFont(name: "GolosText-SemiBold", size: 16)
        lblKycStatus.font = UIFont(name: "GolosText-SemiBold", size: 16)
        labelReferEarn.font = UIFont(name: "GolosText-SemiBold", size: 16)

        labeltotalBalance.font = UIFont(name: "GolosText-Regular", size: 12)
        labelupgrade.font = UIFont(name: "GolosText-Regular", size: 12)
        labelRequired.font = UIFont(name: "GolosText-Regular", size: 12)
        labelInviteFriends.font = UIFont(name: "GolosText-Regular", size: 12)
        
        labelTRC20Crypto.font = UIFont(name: "GolosText-Regular", size: 14)

        labelBankDetails.font = UIFont(name: "GolosText-Regular", size: 14)
        labelChangePassword.font = UIFont(name: "GolosText-Regular", size: 14)
        labelRateApp.font = UIFont(name: "GolosText-Regular", size: 14)
        labelShareApp.font = UIFont(name: "GolosText-Regular", size: 14)
        labelTermsCondition.font = UIFont(name: "GolosText-Regular", size: 14)
        labelPrivacyPolicy.font = UIFont(name: "GolosText-Regular", size: 14)
        labelFAQs.font = UIFont(name: "GolosText-Regular", size: 14)
        labelAboutUs.font = UIFont(name: "GolosText-Regular", size: 14)
        labelContactUs.font = UIFont(name: "GolosText-Regular", size: 14)
        labelDeleteAccount.font = UIFont(name: "GolosText-Regular", size: 14)
        labelLogout.font = UIFont(name: "GolosText-Regular", size: 14)
        
        labelLogoutAccount.font = UIFont(name: "GolosText-SemiBold", size: 26)
        labelDelelePopup.font = UIFont(name: "GolosText-SemiBold", size: 26)
        labelAreyouSureDelete.font = UIFont(name: "GolosText-Regular", size: 14)
        labelAreyouSureLogout.font = UIFont(name: "GolosText-Regular", size: 14)
        btnYesDelete.titleLabel?.font =  UIFont(name: "GolosText-SemiBold", size: 16)
        btnYesLogout.titleLabel?.font =  UIFont(name: "GolosText-SemiBold", size: 16)
        btnNoThanks.titleLabel?.font =  UIFont(name: "GolosText-Regular", size: 16)
        btnNoThanksLogout.titleLabel?.font =  UIFont(name: "GolosText-Regular", size: 16)
        
        labelWithdrawCoin.font = UIFont(name: "GolosText-SemiBold", size: 26)
        labelBeforeyou.font = UIFont(name: "GolosText-Regular", size: 14)
        btnCompleteKYC.titleLabel?.font =  UIFont(name: "GolosText-SemiBold", size: 16)
        btnCancelPopup.titleLabel?.font =  UIFont(name: "GolosText-Regular", size: 16)
    }
}

//MARK:- API calling
extension ProfileViewController{
    func postProfileDetailAPI(){

        AppData.ShowProgress()

        var request = URLRequest(url: URL(string: DataManager.shared.getURL(.getUser))!,timeoutInterval: Double.infinity)
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
                        if let jsonData = try? decoder.decode(ProfileResModel.self, from: data) {
                            print("response",jsonData)
                            if jsonData.code == "1" {
                                self.objProfiledata = jsonData.data
                                                                
                                UserDefaultsSettings.storeUserPrefrences(jsonData.data)
                                UserDefaultsSettings.acessToken = jsonData.data?.token ?? ""
                                
                                self.lblUsername.text = jsonData.data?.fullname ?? ""
                                self.lbltotalBalance.text = jsonData.data?.earning ?? ""
                                
                                if jsonData.data?.isKyc == "1"{ // true
                                    // 1
                                    self.imgKYCstatus.image = UIImage(named: "kycSuccess")
                                    self.lblKycStatus.text = "KYC"
                                    self.viewKYCstatus.borderColor = UIColor(hex: "29E337").withAlphaComponent(0.25)
                                    self.viewKYCstatus.backgroundColor = UIColor(hex: "29E337").withAlphaComponent(0.10)
                                }else{
                                    //false   // 0 or 2
                                    self.imgKYCstatus.image = UIImage(named: "kycPending")
                                    self.lblKycStatus.text = "KYC Pending"
                                    self.viewKYCstatus.borderColor = UIColor(hex: "FFB800").withAlphaComponent(0.25)
                                    self.viewKYCstatus.backgroundColor = UIColor(hex: "FFB800").withAlphaComponent(0.10)
                                }
                                     
                                self.imgProfile.kf.setImage(with: URL(string: jsonData.data?.profileImage ?? ""),placeholder: UIImage(named: "user"))
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

struct ProfileResModel: Codable {
    let code: String
    let message: String
    let data: LoginDataResModel?
}

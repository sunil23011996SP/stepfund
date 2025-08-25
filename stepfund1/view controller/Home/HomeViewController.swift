//
//  HomeViewController.swift
//  stepfund1
//
//  Created by satish prajapati on 03/08/25.
//

import UIKit
import CoreMotion
import Kingfisher
import MKMagneticProgress
import CoreMotion
import CommonCrypto

class HomeViewController: UIViewController {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var labelWalkEarn: UILabel!
    @IBOutlet weak var labelYourSteps: UILabel!
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var lblCurrentSteps: UILabel!
    @IBOutlet weak var lblCurrentTotalSteps: UILabel!
    @IBOutlet weak var labelTotalSteps: UILabel!
    @IBOutlet weak var lblTotalSteps: UILabel!
    @IBOutlet weak var magProgress:MKMagneticProgress!

    @IBOutlet weak var labelTotalBalance: UILabel!
    @IBOutlet weak var lblTotalBalance: UILabel!

    @IBOutlet weak var lblSubscriptionName: UILabel!
    @IBOutlet weak var labelupgrade: UILabel!
    
    @IBOutlet weak var labelReferEarn: UILabel!
    @IBOutlet weak var labelInviteFriends: UILabel!

    @IBOutlet weak var labelRules: UILabel!
    @IBOutlet weak var labelViewRulesAnd: UILabel!
    
    var currentStepRunning = true
    var progressValue = 0
    let maxCount: Int = 200
    let pedometer = CMPedometer()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        
        setupViewFont()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.lblUserName.attributedText = AppData.setLabelMultipleColor(firstText: "Hello! ", secondText: "\(UserDefaultsSettings.user?.fullname ?? "")", thirdText: "", fourthText: "", fifthText: "", firstColor: UIColor.white, secondColor: UIColor(hex: "0059FF"), thirdColor: UIColor.clear, fourthColor: UIColor.clear, fifthColor: UIColor.clear)
        
        self.imgProfile.kf.setImage(with: URL(string: UserDefaultsSettings.user?.profileImage ?? ""),placeholder: UIImage(named: "user"))
        
        if Reachability.isConnectedToNetwork(){
            self.getTotalStepAndEarnAPI()
        }else{
            AlertView.showOKTitleAlert(AppConstant.noInternetConnection, viewcontroller: self)
        }
        
        let encryptedBase64 = "LvA2z6VOydGsZL5+7WTgNoS+OvtQ7qlD+tDMQJ8SCIBnU/cBoZWJ+EWAK618/jk72r5ZCZ4wfLVvhQQEk1b8icBNndjIeUubJh8qRCdfolTfdZjqBpxGkPtfaWGfTpFyXVJtJauIpO521L6Z7lBqRcRTTSx5NxCFCNTQGAzN2Wk="

        // Your 32-byte key string
        let key = "xDzIhX1eo7sune1aukb9BrtyMpqwsd2h"

        if let decrypted = decryptAES256CBC(base64String: encryptedBase64, keyString: key) {
            print("Decrypted text: \(decrypted)")
        } else {
            print("Failed to decrypt")
        }

        magProgress.titleLabel.textColor = UIColor.white
        magProgress.titleLabel.textColor = UIColor.white
        //magProgress.inset = 200.0
        magProgress.setProgress(progress: 0, animated: true)
    }
    
    //--------------------------------------------------
    // MARK:- Abstract Method
    //--------------------------------------------------
    class func viewController() -> HomeViewController {
        return UIStoryboard.home.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    }
   
    func setupViewFont(){
        lblUserName.font = UIFont(name: "GolosText-SemiBold", size: 20)
        labelWalkEarn.font = UIFont(name: "GolosText-SemiBold", size: 22)
        labelYourSteps.font = UIFont(name: "GolosText-Regular", size: 14)
        
        lblCurrentSteps.font = UIFont(name: "GolosText-SemiBold", size: 40)
        lblCurrentTotalSteps.font = UIFont(name: "GolosText-Regular", size: 14)

        lblTotalSteps.font = UIFont(name: "GolosText-SemiBold", size: 26)
        labelTotalSteps.font = UIFont(name: "GolosText-Regular", size: 12)
        
        lblTotalBalance.font = UIFont(name: "GolosText-SemiBold", size: 26)
        labelTotalBalance.font = UIFont(name: "GolosText-Regular", size: 12)
        
        lblSubscriptionName.font = UIFont(name: "GolosText-SemiBold", size: 16)
        labelupgrade.font = UIFont(name: "GolosText-Regular", size: 12)
        
        labelRules.font = UIFont(name: "GolosText-SemiBold", size: 16)
        labelViewRulesAnd.font = UIFont(name: "GolosText-Regular", size: 12)
        
        labelReferEarn.font = UIFont(name: "GolosText-SemiBold", size: 16)
        labelInviteFriends.font = UIFont(name: "GolosText-Regular", size: 12)
        
    }
    
    func startButtonTapped() {
        if CMPedometer.isStepCountingAvailable() {
            pedometer.startUpdates(from: Date()) { [weak self] data, error in
                guard let self = self, let data = data, error == nil else {
                    print("Pedometer error: \(error?.localizedDescription ?? "unknown error")")
                    return
                }
                DispatchQueue.main.async {
                    if Int(data.numberOfSteps) < self.maxCount {
                       // data.numberOfSteps += 1
                        let progress = Float(Int(data.numberOfSteps)) / Float(self.maxCount)
                           print(CGFloat(progress))
                        self.magProgress.setProgress(progress: CGFloat(progress), animated: true)
                       }else{
                           print("Progress complete!")
                       }
                    self.lblCurrentSteps.text = "\(data.numberOfSteps)"
                }
            }
        } else {
            print("Step counting not available on this device.")
            self.view.makeToast("Step counting not available on this device.    ")
        }
    }
    
    func decryptAES256CBC(base64String: String, keyString: String) -> String? {
        guard let fullData = Data(base64Encoded: base64String) else {
            print("Invalid Base64 string")
            return nil
        }
        
        // Extract IV (first 16 bytes)
        let iv = fullData.prefix(16)
        // Extract ciphertext (remaining bytes)
        let ciphertext = fullData.dropFirst(16)
        
        guard let keyData = keyString.data(using: .utf8 ), keyData.count == kCCKeySizeAES256 else {
            print("Key must be 32 bytes (256 bits)")
            return nil
        }
        
        
        let bufferSize = ciphertext.count + kCCBlockSizeAES128
        var buffer = Data(count: bufferSize)
        var numBytesDecrypted: size_t = 0
        
        let cryptStatus = buffer.withUnsafeMutableBytes { bufferBytes in
            ciphertext.withUnsafeBytes { ciphertextBytes in
                keyData.withUnsafeBytes { keyBytes in
                    iv.withUnsafeBytes { ivBytes in
                        CCCrypt(
                            CCOperation(kCCDecrypt),
                            CCAlgorithm(kCCAlgorithmAES),
                            CCOptions(kCCOptionPKCS7Padding),
                            keyBytes.baseAddress, kCCKeySizeAES256,
                            ivBytes.baseAddress,
                            ciphertextBytes.baseAddress, ciphertext.count,
                            bufferBytes.baseAddress, bufferSize,
                            &numBytesDecrypted
                        )
                    }
                }
            }
        }
        
        if cryptStatus == kCCSuccess {
            buffer.count = numBytesDecrypted
            return String(data: buffer, encoding: .utf8)
        } else {
            print("Decryption failed with status: \(cryptStatus)")
            return nil
        }
    }

}

//MARK:- Buttom Action
extension HomeViewController{
    
    @IBAction func btnProfileClikced(_ sender: UIButton) {
        let vc = ProfileViewController.viewController()
        navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnPlayPauseClicked(_ sender: UIButton) {
        
        if currentStepRunning {
            //start
            btnPlayPause.setImage(UIImage(named: "StepCount_Pause"), for: .normal)
            startButtonTapped()
        } else {
            //stop
            btnPlayPause.setImage(UIImage(named: "StepCount_Play"), for: .normal)
            pedometer.stopUpdates()
            print("Stopped step counting.")
        }
        currentStepRunning = !currentStepRunning
    }
   
    @IBAction func btnSubscriptionClicked(_ sender: UIButton) {
        let vc = SubscriptionListViewController.viewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnRulesClicked(_ sender: UIButton) {
        let vc = RulesViewController.viewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnReferAndEarnClicked(_ sender: UIButton) {
        let vc = ReferAndEarnVC.viewController()
        vc.invitecode =  UserDefaultsSettings.user?.referralCode ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnWalletAmountClicked(_ sender: UIButton) {
        
        if  UserDefaultsSettings.user?.isKyc == "0"{ // true
            let vc = VerifyIdentityViewController.viewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if UserDefaultsSettings.user?.isKyc == "1"{
            let vc = WalletViewController.viewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if UserDefaultsSettings.user?.isKyc == "2"{
            AlertView.showOKTitleAlert("KYC verification request already submitted.", viewcontroller: self)
        }
        
        
        
    }
}

//MARK:- API calling
extension HomeViewController{
    
    func getTotalStepAndEarnAPI(){

        AppData.ShowProgress()

        var request = URLRequest(url: URL(string: DataManager.shared.getURL(.TotalStepEarn))!,timeoutInterval: Double.infinity)
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
                        if let jsonData = try? decoder.decode(TotalStepAndEarnResModel.self, from: data) {
                            print("response",jsonData)
                            if jsonData.code == "1" {
                                
                                self.lblTotalBalance.text = jsonData.data?.total_withdraw ?? ""
                                self.lblTotalSteps.text = jsonData.data?.total_step ?? ""
                                
                                self.getKeysAPI()
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
    
    
    func getKeysAPI(){

        AppData.ShowProgress()

        var request = URLRequest(url: URL(string: DataManager.shared.getURL(.GetKeysList))!,timeoutInterval: Double.infinity)
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
            
            
            
            print(AES256.decrypt(base64String: String(data: data, encoding: .utf8)!))
            
           
        }

        task.resume()

    }
    func postGetKeysDecryptionAPI(resEncValue:String){
                
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
                        if let jsonData = try? decoder.decode(GetAWSKeyResModel.self, from: data) {
                            print("response",jsonData)
                            if jsonData.code == "1" {
                                
                                UserDefaults.standard.set(jsonData.data?.aws_keys?.aws_access_key_id, forKey: "aws_access_key")
                                UserDefaults.standard.set(jsonData.data?.aws_keys?.aws_secret_key_id, forKey: "aws_secret_key")
                                UserDefaults.standard.set(jsonData.data?.aws_keys?.aws_bucket_name, forKey: "aws_bucket_name")
                                
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

struct TotalStepAndEarnResModel: Codable {
    let code: String
    let message: String
    let data: TotalStepAndEarnDataResModel?
}

struct TotalStepAndEarnDataResModel: Codable {
   
    let earning, total_step, total_withdraw: String?

    enum CodingKeys: String, CodingKey {
        case earning, total_step, total_withdraw
        
    }
}


struct GetAWSKeyResModel: Codable {
    let code: String
    let message: String
    let data: GetAWSKeyDataResModel?
}

struct GetAWSKeyDataResModel: Codable {
   
    let aws_keys: GetAWSKeyDataAWSKeyResModel?

    enum CodingKeys: String, CodingKey {
        case aws_keys
        
    }
}
struct GetAWSKeyDataAWSKeyResModel: Codable {
   
    let aws_access_key_id: String?
    let aws_secret_key_id: String?
    let aws_bucket_name: String?
    let awsKeys: String?
    let aws_region: String?
    let aws_ios_bucket_path: String?
    

    enum CodingKeys: String, CodingKey {
        case aws_access_key_id
        case aws_secret_key_id
        case aws_bucket_name
        case awsKeys
        case aws_region
        case aws_ios_bucket_path
        
    }
}

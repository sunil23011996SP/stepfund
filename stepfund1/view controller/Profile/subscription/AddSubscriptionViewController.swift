//
//  AddSubscriptionViewController.swift
//  stepfund1
//
//  Created by satish prajapati on 06/08/25.
//

import UIKit
import Photos
import CropViewController
import PhotosUI
import Kingfisher


class AddSubscriptionViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var labelAddSubscription: UILabel!
    @IBOutlet weak var labelStepFund: UILabel!
    @IBOutlet weak var lblPleaseMakePayment: UILabel!
    @IBOutlet weak var labelBankDetails: UILabel!
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var lblAccountNo: UILabel!
    @IBOutlet weak var lblSwiftCode: UILabel!
    @IBOutlet weak var labelUSDT: UILabel!
    @IBOutlet weak var lblUSDT: UILabel!
    @IBOutlet weak var labelUplaodPayment: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var imgUser: UIImageView!


    var isImageSelected = false
    var strAmount = ""
    var strSelectedId = ""
    var selectedProfileImage: UIImage?
    var picker:UIImagePickerController? = UIImagePickerController()
    var isCropControllerOpen = false
    var subscriptionId = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker?.delegate = self
        
        self.imgUser.contentMode = .scaleAspectFill
        
        labelAddSubscription.font = UIFont(name: "GolosText-SemiBold", size: 16)
        labelStepFund.font = UIFont(name: "GolosText-SemiBold", size: 26)
        lblPleaseMakePayment.font = UIFont(name: "GolosText-Regular", size: 14)
        labelBankDetails.font = UIFont(name: "GolosText-SemiBold", size: 14)
        lblAccountNo.font = UIFont(name: "GolosText-Regular", size: 14)
        lblSwiftCode.font = UIFont(name: "GolosText-Regular", size: 14)
        labelUSDT.font = UIFont(name: "GolosText-SemiBold", size: 14)
        lblUSDT.font = UIFont(name: "GolosText-Regular", size: 14)
        labelUplaodPayment.font = UIFont(name: "GolosText-SemiBold", size: 14)
        btnSubmit.titleLabel?.font =  UIFont(name: "GolosText-SemiBold", size: 16)

        lblPleaseMakePayment.text = "Please make a payment of ₹\(strAmount) to the bank details, or crypto (any one) provided below and upload the payment screenshot. Your subscription will begin once the payment is approved by the admin."
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if Reachability.isConnectedToNetwork(){
            
            self.postGetAdminBankDetailAPI()
            
        }else{
            AlertView.showOKTitleAlert(AppConstant.noInternetConnection, viewcontroller: self)
        }
        
        if isCropControllerOpen == false {
            //self.userProfileAPI()
            self.isCropControllerOpen = false
        }
    }
    
    //--------------------------------------------------
    // MARK:- Abstract Method
    //--------------------------------------------------
    class func viewController() -> AddSubscriptionViewController {
        return UIStoryboard.home.instantiateViewController(withIdentifier: "AddSubscriptionViewController") as! AddSubscriptionViewController
    }
    
    //--------------------------------------------------
    // MARK:- Button Action
    //--------------------------------------------------
    @IBAction func btnSubmitClikced(_ sender: UIButton) {
        if validate() {
            if Reachability.isConnectedToNetwork(){
                self.uploadFile(withImage: selectedProfileImage!)
            }else{
                AlertView.showOKTitleAlert(AppConstant.noInternetConnection, viewcontroller: self)
            }
            
        }
    }
    @IBAction func btnCopyCodeClicked(_ sender: UIButton) {
        self.view.makeToast("Text copied to clipboard!")
    }
    @IBAction func backButtonClikced(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
        
    @IBAction func btnUploadProfile(_ sender: UIButton) {
        self.view.endEditing(true)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.checkCameraAccess()
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default){
            UIAlertAction in
            self.checkLibraryUsagePermission()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openPhotoLibrary()
    {
        DispatchQueue.main.async {
            self.picker!.allowsEditing = false
            self.picker!.sourceType = .photoLibrary
            self.present(self.picker!, animated: true, completion: nil)
        }
    }
    
    func openCamera()
    {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .camera
                imagePicker.delegate = self
                self.present(imagePicker, animated: true)
            }
            else
            {
                print("No camera available")
            }
        }
    }
    //MARK:- Camera and photo library access check
    func checkLibraryUsagePermission()
    {
        var accessGranted = false
        let status = PHPhotoLibrary.authorizationStatus()
        
        if (status == PHAuthorizationStatus.authorized)
        {
            // Access has been granted.
            accessGranted = true
            
            self.openPhotoLibrary()
        }
        else if (status == PHAuthorizationStatus.denied)
        {
            accessGranted = false
            self.presentLibraryUsageSettings()
        }
        else if (status == PHAuthorizationStatus.notDetermined)
        {
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                    accessGranted = true
                    self.openPhotoLibrary()
                }
                else {
                    accessGranted = false
                }
            })
        }
        else if (status == PHAuthorizationStatus.restricted) {
            // Restricted access - normally won't happen.
        }
        //        return accessGranted
    }
    func presentLibraryUsageSettings()
    {
        AlertView.showMessageAlert("Gallary Permission necessary", viewcontroller: self)
    }
    
    func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            print("Denied, request permission from settings")
            presentCameraSettings()
        case .restricted:
            print("Restricted, device owner must approve")
        case .authorized:
            print("Authorized, proceed")
            self.openCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                    self.openCamera()
                } else {
                    print("Permission denied")
                }
            }
        }
    }
    
    func presentCameraSettings()
    {
        AlertView.showMessageAlert("Camera Permission necessary", viewcontroller: self)
    }
    
    //MARK:- ImagePicker delegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.dismiss(animated: false, completion: nil)
            presentCropViewController(image: chosenImage)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
   
}
//MARK: - Validation Check
extension AddSubscriptionViewController {
    func validate() -> Bool
    {
        if selectedProfileImage == nil {
            AlertView.showOKTitleAlert("Please add payment success screenshot", viewcontroller: self)
            return false
        }
        return true
    }
}
//MARK:- API calling
extension AddSubscriptionViewController{
    
    func uploadFile(withImage image: UIImage) {
        
        let uploader = S3Uploader()
        let filename = "\(12.generateRandomStringWithLength()).jpg"
        
        DispatchQueue.main.async {
            AppData.ShowProgress()
            uploader.uploadImage(image: image, folder: "subscription", fileName: filename) { result in
                switch result {
                case .success(let url):
                    print("Uploaded Image URL: \(url)")
                    AppData.ShowProgress()
                    self.postAddSubscriptionEncryptionAPI(imageurl: filename)
                case .failure(let error):
                    AppData.HideProgress()
                    print("Upload error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func postGetAdminBankDetailAPI(){

        AppData.ShowProgress()

        var request = URLRequest(url: URL(string: DataManager.shared.getURL(.getAdminBank))!,timeoutInterval: Double.infinity)
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
                        if let jsonData = try? decoder.decode(addSubscriptionResModel.self, from: data) {
                            print("response",jsonData)
                            if jsonData.code == "1" {
                                self.lblBankName.text = "Bank Name: \(jsonData.data?.bank_name ?? "")"
                                self.lblAccountNo.text = "Account Number: \(jsonData.data?.account_number ?? "")"
                                self.lblSwiftCode.text = "SWIFT Code: \(jsonData.data?.iban_number ?? "")"
                                self.lblUSDT.text = "\(jsonData.data?.usdt ?? "")"
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
    
    
    func postAddSubscriptionEncryptionAPI(imageurl:String){
        AppData.ShowProgress()
        
        let parameters = "{\"subscription_id\":\"\(self.strSelectedId)\",\"image\":\"\(imageurl)\"}"
                    
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: DataManager.shared.getURL(.getEncryption))!,timeoutInterval: Double.infinity)
        request.addValue("Gemflb3MR+S7AcOvPSfNSA==", forHTTPHeaderField: "api-key")
        request.addValue("en", forHTTPHeaderField: "accept-language")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
            self.postAddSubscriptionAPI(envalue: String(data: data, encoding: .utf8)!)
        }
        task.resume()

    }
    
    func postAddSubscriptionAPI(envalue:String){

        let postData = envalue.data(using: .utf8)

        var request = URLRequest(url: URL(string: DataManager.shared.getURL(.addSubscription))!,timeoutInterval: Double.infinity)
        request.addValue("Gemflb3MR+S7AcOvPSfNSA==", forHTTPHeaderField: "api-key")
        request.addValue("en", forHTTPHeaderField: "accept-language")
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.addValue(UserDefaultsSettings.user?.encToken ?? "", forHTTPHeaderField: "token")


        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
            self.postAddSubscriptionDecryptionAPI(resEncValue: String(data: data, encoding: .utf8)!)
        }

        task.resume()

    }
    
    func postAddSubscriptionDecryptionAPI(resEncValue:String){
                
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
                    let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    let decoder = JSONDecoder()
                        if let jsonData = try? decoder.decode(AddBankDetailsResModel.self, from: data) {
                            AppData.HideProgress()
                        print("response",jsonData)
                            DispatchQueue.main.async {
                                if jsonData.code == "1"{
                                    AlertView.showAlert(jsonData.message ?? "", strMessage: "", button: ["OK"], viewcontroller: self) { (btn) in
                                        if btn == 0 {
                                            self.navigationController?.popViewController(animated: true)
                                        }
                                        else{
                                            self.dismiss(animated: true, completion: nil)
                                        }
                                    }
                                }
                                else if jsonData.code == "-1"{
                                    AppData.HideProgress()
                                    AlertView.showAlert(jsonData.message ?? "", strMessage: "", button: ["OK"], viewcontroller: self) { (btn) in
                                        if btn == 0 {
                                            let vc = LoginViewController.viewController()
                                            UserDefaultsSettings.clearDefaultData()
                                            self.navigationController?.pushViewController(vc, animated: true)
                                        }
                                    }
                                }
                                else{
                                    AlertView.showOKTitleAlert(jsonData.message ?? "", viewcontroller: self)
                                }
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

extension AddSubscriptionViewController: CropViewControllerDelegate {
    
    func presentCropViewController (image: UIImage) {
        let image: UIImage = image
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        
        isCropControllerOpen = true
        present(cropViewController, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        self.selectedProfileImage = image
        self.imgUser.image = image
        self.isImageSelected = true
        self.dismiss(animated: true)
        
        //upload profile picture aws api
       // self.updateProfilePicture()

    }
}

struct addSubscriptionResModel: Codable {
    let code: String
    let message: String
    let data: addSubscriptionDataResModel?
}

// MARK: - DataClass
struct addSubscriptionDataResModel: Codable {
    let bank_name, account_number, account_holder_name, iban_number, usdt: String?
    
    
    enum CodingKeys: String, CodingKey {
        case bank_name, account_number, account_holder_name, iban_number, usdt
       
    }
}


//
//  EditProfileViewController.swift
//  stepfund1
//
//  Created by satish prajapati on 06/08/25.
//

import UIKit
import CountryPickerView
import Photos
import CropViewController
import PhotosUI
import Kingfisher
import AWSCore
import AWSS3


class EditProfileViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var labelEditProfile: UILabel!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtCountrtCode: CountryPickerView!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var imgUser: UIImageView!

    
    var strFullname = ""
    var strImage = ""
    var strEmail = ""
    var strCountryCode = ""
    var strPhoneno = ""

    var selectedCountryShortCode = ""
    var isImageSelected = false
    var selectedProfileImage: UIImage?
    
    var picker:UIImagePickerController? = UIImagePickerController()
    var isCropControllerOpen = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgUser.kf.setImage(with: URL(string: UserDefaultsSettings.user?.profileImage ?? ""),placeholder: UIImage(named: "user"))
        
        labelEditProfile.font = UIFont(name: "GolosText-SemiBold", size: 16)
        btnUpdate.titleLabel?.font =  UIFont(name: "GolosText-SemiBold", size: 16)
        txtFullName.font = UIFont(name: "GolosText-Regular", size: 14)
        txtEmail.font = UIFont(name: "GolosText-Regular", size: 14)
        txtMobileNumber.font = UIFont(name: "GolosText-Regular", size: 14)
        
        txtFullName.attributedPlaceholder = NSAttributedString(
            string: "Full Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )
        txtEmail.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )
        txtMobileNumber.attributedPlaceholder = NSAttributedString(
            string: "Mobile Number",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )

        picker?.delegate = self
        
        self.imgUser.contentMode = .scaleAspectFill
       
        txtFullName.text = strFullname
        txtEmail.text = strEmail
        txtMobileNumber.text = strPhoneno
        
        txtCountrtCode.countryDetailsLabel.textAlignment = .center
        txtCountrtCode.countryDetailsLabel.text = strCountryCode
        txtCountrtCode.font = UIFont(name: "GolosText-Regular", size: 14)!
        txtCountrtCode.textColor = UIColor.white
        txtCountrtCode.showCountryCodeInView = false
        txtCountrtCode.showCountryNameInView = false
        txtCountrtCode.showPhoneCodeInView = true

        txtCountrtCode.dataSource = self
        txtCountrtCode.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        if isCropControllerOpen == false {
            //self.userProfileAPI()
            self.isCropControllerOpen = false
        }
        
    }
    
    //--------------------------------------------------
    // MARK:- Abstract Method
    //--------------------------------------------------
    class func viewController() -> EditProfileViewController {
        return UIStoryboard.main.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
    }
    
    //--------------------------------------------------
    // MARK:- Button Action
    //--------------------------------------------------
    @IBAction func btnSubmitClikced(_ sender: UIButton) {
        if validate() {
            if isImageSelected == true{
                uploadFile(withImage: imgUser.image!)
            }else{
                self.postEncryptionAPI(imageurl: "")
            }
        }
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
extension EditProfileViewController {
    func validate() -> Bool
    {
        if txtEmail.text!.isEmpty {
            if !Validation().isEmailValidate(testStr: txtEmail.text!){
                AlertView.showOKTitleAlert("Please enter valid email address", viewcontroller: self)
                return false
            }
            AlertView.showOKTitleAlert("Please enter email address", viewcontroller: self)
            return false
        }
        
        if txtEmail.text!.isEmpty {
            AlertView.showOKTitleAlert("Please enter email", viewcontroller: self)
            return false
        }
        
        if txtMobileNumber.text!.isEmpty {
            AlertView.showOKTitleAlert("Please enter mobile number", viewcontroller: self)
            return false
        }
        
        
        return true
        
    }
}
//MARK:- API calling
extension EditProfileViewController{
    
    func uploadFile(withImage image: UIImage) {
        
        let uploader = S3Uploader()
        let filename = "\(12.generateRandomStringWithLength()).jpg"
        
        DispatchQueue.main.async {
            AppData.ShowProgress()
            uploader.uploadImage(image: image, folder: "user", fileName: filename) { result in
                switch result {
                case .success(let url):
                    print("Uploaded Image URL: \(url)")
                    AppData.ShowProgress()
                    self.imgUser.kf.setImage(with: url,placeholder: UIImage(named: "user"))
                    self.postEncryptionAPI(imageurl: filename)
                case .failure(let error):
                    AppData.HideProgress()
                    print("Upload error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    func postEncryptionAPI(imageurl:String){
        AppData.ShowProgress()
        
        var parameters = ""
        if isImageSelected{
            parameters = "{ \"fullname\":\"\(txtFullName.text ?? "")\", \"email\": \"\(txtEmail.text ?? "")\", \"country_code\": \"\(strCountryCode)\", \"phone\": \"\(txtMobileNumber.text ?? "")\", \"profile_image\": \"\(imageurl)\",\"short_code\":\"\(selectedCountryShortCode)\" }"
            
        }else{
                        
            parameters = "{ \"fullname\":\"\(txtFullName.text ?? "")\", \"email\": \"\(txtEmail.text ?? "")\", \"country_code\": \"\(strCountryCode)\", \"phone\": \"\(txtMobileNumber.text ?? "")\",\"short_code\":\"\(selectedCountryShortCode)\" }"
        }
       
            
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
            self.postEditUserProfileAPI(envalue: String(data: data, encoding: .utf8)!)
        }
        task.resume()

    }
    
    func postEditUserProfileAPI(envalue:String){

        let postData = envalue.data(using: .utf8)

        var request = URLRequest(url: URL(string: DataManager.shared.getURL(.editProfile))!,timeoutInterval: Double.infinity)
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

extension EditProfileViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        let title = "Selected Country"
        let message = "Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)"
        
        selectedCountryShortCode = country.code
        strCountryCode = country.phoneCode
        
    }
}
extension EditProfileViewController: CountryPickerViewDataSource {
    //    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
    //        return "Select a Country"
    //    }
    //
    
    func closeButtonNavigationItem(in countryPickerView: CountryPickerView) -> UIBarButtonItem? {
        return nil
    }
    
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return countryPickerView.tag == txtCountrtCode.tag
    }
    
    func showCountryCodeInList(in countryPickerView: CountryPickerView) -> Bool {
       return countryPickerView.tag == txtCountrtCode.tag
    }
}
//--------------------------------------------------------------------
// MARK:- Extension - CropViewControllerDelegate
//--------------------------------------------------------------------
extension EditProfileViewController: CropViewControllerDelegate {
    
    func presentCropViewController(image: UIImage) {
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
extension Int {
    //MARK: - Upload Image File Name Generate -
    public func generateRandomStringWithLength() -> String {
        let randomString: NSMutableString = NSMutableString(capacity: self)
        let letters: NSMutableString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var i: Int = 0

        while i < self {
            let randomIndex: Int = Int(arc4random_uniform(UInt32(letters.length)))
            randomString.append("\(Character( UnicodeScalar( letters.character(at: randomIndex))!))")
            i += 1
        }
        return String(randomString)
    }
    
}

extension UIImage{
    func resizedImage(newSize: CGSize) -> UIImage {
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
extension Data {

  var format: String {
    let array = [UInt8](self)
    let ext: String
    switch (array[0]) {
    case 0xFF:
        ext = "jpg"
    case 0x89:
        ext = "png"
    case 0x47:
        ext = "gif"
    case 0x49, 0x4D :
        ext = "tiff"
    default:
        ext = "unknown"
    }
    return ext
   }

}

//
//  VerifyIdentityViewController.swift
//  stepfund1
//
//  Created by satish prajapati on 14/08/25.
//

import UIKit
import CountryPickerView
import Photos
import CropViewController
import PhotosUI
import Kingfisher
import AWSCore
import AWSS3

class VerifyIdentityViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var labelVerifyYour: UILabel!
    @IBOutlet weak var labelPlease: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtCountrtCode: CountryPickerView!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var imgviewDocument: UIImageView!
    @IBOutlet weak var txtDateOfBirth: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var labelUploadDocument: UILabel!
    @IBOutlet weak var labelIdProof: UILabel!

    var selectedCountryShortCode = ""
    var isImageSelected = false
    var selectedProfileImage: UIImage?
    var strCountryCode = ""
    var picker:UIImagePickerController? = UIImagePickerController()
    var isCropControllerOpen = false

    override func viewDidLoad() {
        super.viewDidLoad()
                
        labelVerifyYour.font = UIFont(name: "GolosText-SemiBold", size: 16)
        labelPlease.font = UIFont(name: "GolosText-Regular", size: 14)
        
        labelUploadDocument.font = UIFont(name: "GolosText-SemiBold", size: 16)
        labelIdProof.font = UIFont(name: "GolosText-Regular", size: 14)

        
        btnSubmit.titleLabel?.font =  UIFont(name: "GolosText-SemiBold", size: 16)
        txtFullName.font = UIFont(name: "GolosText-Regular", size: 14)
        txtCountry.font = UIFont(name: "GolosText-Regular", size: 14)
        txtMobileNumber.font = UIFont(name: "GolosText-Regular", size: 14)
        txtDateOfBirth.font = UIFont(name: "GolosText-Regular", size: 14)
        txtAddress.font = UIFont(name: "GolosText-Regular", size: 14)
        
        
        txtFullName.attributedPlaceholder = NSAttributedString(
            string: "Full Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )
        txtCountry.attributedPlaceholder = NSAttributedString(
            string: "Country",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )
        txtMobileNumber.attributedPlaceholder = NSAttributedString(
            string: "Mobile Number",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )
        txtDateOfBirth.attributedPlaceholder = NSAttributedString(
            string: "Date of birth",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )
        txtAddress.attributedPlaceholder = NSAttributedString(
            string: "Address",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.20)]
        )

        picker?.delegate = self
        
        self.imgviewDocument.contentMode = .scaleAspectFill
        
        txtCountrtCode.countryDetailsLabel.textAlignment = .center
        txtCountrtCode.countryDetailsLabel.text = strCountryCode
        txtCountrtCode.font = UIFont(name: "GolosText-Regular", size: 14)!
        txtCountrtCode.textColor = UIColor.white
        txtCountrtCode.showCountryCodeInView = false
        txtCountrtCode.showCountryNameInView = false
        txtCountrtCode.showPhoneCodeInView = true

        txtCountrtCode.dataSource = self
        txtCountrtCode.delegate = self
        
        self.txtDateOfBirth.setDatePickerAsInputViewFor(target: self, selector: #selector(dateSelected))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if isCropControllerOpen == false {
            self.isCropControllerOpen = false
        }
        strCountryCode = txtCountrtCode.countryDetailsLabel.text ?? ""

    }
    
    //--------------------------------------------------
    // MARK:- Abstract Method
    //--------------------------------------------------
    class func viewController() -> VerifyIdentityViewController {
        return UIStoryboard.main.instantiateViewController(withIdentifier: "VerifyIdentityViewController") as! VerifyIdentityViewController
    }
    
    //--------------------------------------------------
    // MARK:- Button Action
    //--------------------------------------------------
    @IBAction func btnSubmitClikced(_ sender: UIButton) {
        if validate() {
            uploadFile(withImage: imgviewDocument.image!)
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
    
    
    @objc func dateSelected() {
        if let datePicker = self.txtDateOfBirth.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-YYYY"
            
            self.txtDateOfBirth.text = dateFormatter.string(from: datePicker.date)
        }
        self.txtDateOfBirth.resignFirstResponder()
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
extension VerifyIdentityViewController {
    func validate() -> Bool
    {
        if txtFullName.text!.isEmpty {
            AlertView.showOKTitleAlert("Please enter full name.", viewcontroller: self)
            return false
        }
        if txtCountry.text!.isEmpty {
            AlertView.showOKTitleAlert("Please enter country.", viewcontroller: self)
            return false
        }
        
        if txtMobileNumber.text!.isEmpty {
            AlertView.showOKTitleAlert("Please enter mobile number", viewcontroller: self)
            return false
        }
        if txtAddress.text!.isEmpty {
            AlertView.showOKTitleAlert("Please enter address.", viewcontroller: self)
            return false
        }
        if txtDateOfBirth.text!.isEmpty {
            AlertView.showOKTitleAlert("Please enter date of birth", viewcontroller: self)
            return false
        }
        
        if selectedProfileImage == nil {
            AlertView.showOKTitleAlert("Please upload document", viewcontroller: self)
            return false
        }
        
        return true
        
    }
}

//MARK:- API calling
extension VerifyIdentityViewController{
    
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
        DispatchQueue.main.async {
            parameters = "{\"fullname\":\"\(self.txtFullName.text ?? "")\",\"country_code\":\"\(self.strCountryCode)\",\"phone\":\"\(self.txtMobileNumber.text ?? "")\",\"country\":\"\(self.txtCountry.text ?? "")\",\"address\":\"\(self.txtAddress.text ?? "")\",\"dob\":\"\(self.txtDateOfBirth.text ?? "")\",\"upload_doc\":\"\(imageurl)\"}"
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
            self.postDoKYCAPI(envalue: String(data: data, encoding: .utf8)!)
        }
        task.resume()

    }
    
    func postDoKYCAPI(envalue:String){

        let postData = envalue.data(using: .utf8)

        var request = URLRequest(url: URL(string: DataManager.shared.getURL(.DOKYC))!,timeoutInterval: Double.infinity)
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

extension VerifyIdentityViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        let title = "Selected Country"
        let message = "Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)"
        
        selectedCountryShortCode = country.code
        strCountryCode = country.phoneCode
        
    }
}
extension VerifyIdentityViewController: CountryPickerViewDataSource {
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
extension VerifyIdentityViewController: CropViewControllerDelegate {
    
    func presentCropViewController(image: UIImage) {
        let image: UIImage = image
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        
        isCropControllerOpen = true
        present(cropViewController, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        self.selectedProfileImage = image
        self.imgviewDocument.image = image
        self.isImageSelected = true
        self.dismiss(animated: true)
    }
}

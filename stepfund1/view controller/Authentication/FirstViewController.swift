//
//  FirstViewController.swift
//  stepfund1
//
//  Created by satish prajapati on 21/07/25.
//

import UIKit

class FirstViewController: UIViewController {

    
    @IBOutlet weak var labelTrackYour: UILabel!
    @IBOutlet weak var labelStartWalking: UILabel!
    @IBOutlet weak var labelAlreadyhave: UILabel!
    @IBOutlet weak var labelByClicking: UILabel!
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        labelStartWalking.font = UIFont(name: "GolosText-Regular", size: 40)
        btnCreateAccount.titleLabel?.font =  UIFont(name: "GolosText-SemiBold", size: 16)
        labelAlreadyhave.font = UIFont(name: "GolosText-Regular", size: 14)
        btnLogin.titleLabel?.font =  UIFont(name: "GolosText-Bold", size: 14)
        labelByClicking.font = UIFont(name: "GolosText-Regular", size: 12)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        labelTrackYour.font = UIFont(name: "GolosText-Black", size: 45)
    }
    
    //--------------------------------------------------
    // MARK:- Abstract Method
    //--------------------------------------------------
    class func viewController() -> FirstViewController {
        return UIStoryboard.main.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
    }
    
    //--------------------------------------------------
    // MARK:- Button Action
    //--------------------------------------------------
    
    @IBAction func btnCreateAccountClicked(_ sender: UIButton) {
        let vc = SignupVC.viewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnLoginClicked(_ sender: UIButton) {
        let vc = LoginViewController.viewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnTermsClicked(_ sender: UIButton) {
        
    }
    @IBAction func btnPrivacyClicked(_ sender: UIButton) {
        
    }
    
}

//
//  FirstViewController.swift
//  stepfund1
//
//  Created by satish prajapati on 21/07/25.
//

import UIKit

class FirstViewController: UIViewController,UIScrollViewDelegate {

    
    @IBOutlet weak var labelTrackYour: UILabel!
    @IBOutlet weak var labelStartWalking: UILabel!
    @IBOutlet weak var labelAlreadyhave: UILabel!
    @IBOutlet weak var labelByClicking: UILabel!
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides:[FirstScreenContent] = [];

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        scrollView.delegate = self
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
        
        navigationController?.isNavigationBarHidden = true

        btnCreateAccount.titleLabel?.font =  UIFont(name: "GolosText-SemiBold", size: 16)
        labelAlreadyhave.font = UIFont(name: "GolosText-Regular", size: 14)
        btnLogin.titleLabel?.font =  UIFont(name: "GolosText-Bold", size: 14)
        labelByClicking.font = UIFont(name: "GolosText-Regular", size: 12)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
        let vc = SignUpViewController.viewController()
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
    
    // MARK: - UIScrollViewDelegate

      func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
          let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
          pageControl.currentPage = Int(pageNumber)
      }
    
    func createSlides() -> [FirstScreenContent] {

        let slide1:FirstScreenContent = Bundle.main.loadNibNamed("FirstScreenContent", owner: self, options: nil)?.first as! FirstScreenContent
        slide1.labelTitle.font = UIFont(name: "GolosText-SemiBold", size: 26)
        slide1.labelDesc.font = UIFont(name: "GolosText-Regular", size: 14)

        slide1.labelTitle.text = "Track Your Steps, Earn Rewards"
        slide1.labelDesc.text = "Start walking and watch your steps turn into silver coins every day."
        
        let slide2:FirstScreenContent = Bundle.main.loadNibNamed("FirstScreenContent", owner: self, options: nil)?.first as! FirstScreenContent
        slide1.labelTitle.font = UIFont(name: "GolosText-SemiBold", size: 26)
        slide1.labelDesc.font = UIFont(name: "GolosText-Regular", size: 14)
        slide1.labelTitle.text = "Track Your History & Cash Out"
        slide1.labelDesc.text = "Start walking and watch your steps turn into silver coins every day."
        
        let slide3:FirstScreenContent = Bundle.main.loadNibNamed("FirstScreenContent", owner: self, options: nil)?.first as! FirstScreenContent
        slide1.labelTitle.font = UIFont(name: "GolosText-SemiBold", size: 26)
        slide1.labelDesc.font = UIFont(name: "GolosText-Regular", size: 14)
        slide1.labelTitle.text = "Walk More, Earn More"
        slide1.labelDesc.text = "Start walking and watch your steps turn into silver coins every day."
                
        return [slide1, slide2, slide3]
    }
    
    
    func setupSlideScrollView(slides : [FirstScreenContent]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
    }
    
    func scrollView(_ scrollView: UIScrollView, didScrollToPercentageOffset percentageHorizontalOffset: CGFloat) {
        if(pageControl.currentPage == 0) {
            let pageUnselectedColor: UIColor = fade(fromRed: 255/255, fromGreen: 255/255, fromBlue: 255/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            pageControl.pageIndicatorTintColor = pageUnselectedColor
        
            let bgColor: UIColor = fade(fromRed: 103/255, fromGreen: 58/255, fromBlue: 183/255, fromAlpha: 1, toRed: 255/255, toGreen: 255/255, toBlue: 255/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            slides[pageControl.currentPage].backgroundColor = bgColor
            
            let pageSelectedColor: UIColor = fade(fromRed: 81/255, fromGreen: 36/255, fromBlue: 152/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            pageControl.currentPageIndicatorTintColor = pageSelectedColor
        }
    }
    
    
    func fade(fromRed: CGFloat,
              fromGreen: CGFloat,
              fromBlue: CGFloat,
              fromAlpha: CGFloat,
              toRed: CGFloat,
              toGreen: CGFloat,
              toBlue: CGFloat,
              toAlpha: CGFloat,
              withPercentage percentage: CGFloat) -> UIColor {
        
        let red: CGFloat = (toRed - fromRed) * percentage + fromRed
        let green: CGFloat = (toGreen - fromGreen) * percentage + fromGreen
        let blue: CGFloat = (toBlue - fromBlue) * percentage + fromBlue
        let alpha: CGFloat = (toAlpha - fromAlpha) * percentage + fromAlpha
        
        // return the fade colour
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}

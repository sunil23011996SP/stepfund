//
//  StepCoutingDemoVC.swift
//  stepfund1
//
//  Created by satish prajapati on 07/08/25.
//

import UIKit
import UIKit
import CoreMotion

class StepCoutingDemoVC: UIViewController {

        let pedometer = CMPedometer()
        var stepCountLabel: UILabel!
        var startButton: UIButton!

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            setupUI()
        }
    
    //--------------------------------------------------
    // MARK:- Abstract Method
    //--------------------------------------------------
    class func viewController() -> StepCoutingDemoVC {
        return UIStoryboard.home.instantiateViewController(withIdentifier: "StepCoutingDemoVC") as! StepCoutingDemoVC
    }

        func setupUI() {
            // Step Count Label
            stepCountLabel = UILabel()
            stepCountLabel.translatesAutoresizingMaskIntoConstraints = false
            stepCountLabel.text = "Steps: 0"
            stepCountLabel.font = UIFont.systemFont(ofSize: 24)
            stepCountLabel.textAlignment = .center
            view.addSubview(stepCountLabel)

            // Start Button
            startButton = UIButton(type: .system)
            startButton.translatesAutoresizingMaskIntoConstraints = false
            startButton.setTitle("Start Counting", for: .normal)
            startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
            view.addSubview(startButton)

            // Constraints
            NSLayoutConstraint.activate([
                stepCountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                stepCountLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),

                startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                startButton.topAnchor.constraint(equalTo: stepCountLabel.bottomAnchor, constant: 30)
            ])
        }

        @objc func startButtonTapped() {
            if CMPedometer.isStepCountingAvailable() {
                pedometer.startUpdates(from: Date()) { [weak self] data, error in
                    guard let self = self, let data = data, error == nil else {
                        print("Pedometer error: \(error?.localizedDescription ?? "unknown error")")
                        return
                    }

                    DispatchQueue.main.async {
                        self.stepCountLabel.text = "Steps: \(data.numberOfSteps)"
                    }
                }
            } else {
                print("Step counting not available on this device.")
            }
        }
    }


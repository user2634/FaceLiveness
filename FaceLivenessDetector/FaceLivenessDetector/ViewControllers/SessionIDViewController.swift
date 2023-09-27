//
//  SessionIDViewController.swift
//  FaceLivenessDetector
//
//  Created by DN040801DDF on 25.09.2023.
//

import UIKit

class SessionIDViewController: UIViewController {
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var faceDetectorButton: UIButton!
    
    var sessionID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customGreenColor = UIColor(red: 79.0/255.0, green: 150.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        
        idLabel.text = "SessionID:\(sessionID ?? "")"
        
        faceDetectorButton.setTitle("Open face detector", for: .normal)
        faceDetectorButton.backgroundColor = UIColor.clear
        faceDetectorButton.setTitleColor(customGreenColor, for: .normal)
        faceDetectorButton.layer.borderWidth = 0.5
        faceDetectorButton.layer.borderColor = customGreenColor.cgColor
        faceDetectorButton.layer.cornerRadius = 10
    }

    @IBAction func openFaceDetector(_ sender: Any) {
        print(self.sessionID)
        self.showFaceDetectorViewController(sessionID: self.sessionID ?? "")
    }
    
    
    func showFaceDetectorViewController(sessionID: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detectorVC = storyboard.instantiateViewController(withIdentifier: "FaceLivenessDetectorViewController") as? FaceLivenessDetectorViewController {
            detectorVC.sessionID = sessionID
            self.navigationController?.pushViewController(detectorVC, animated: true)
        }
    }

}

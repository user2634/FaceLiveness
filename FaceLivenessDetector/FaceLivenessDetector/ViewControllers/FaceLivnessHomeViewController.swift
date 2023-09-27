//
//  ViewController.swift
//  FaceLivenessDetector
//
//  Created by DN040801DDF on 24.09.2023.
//

import UIKit

class FaceLivnessHomeViewController: UIViewController {

    @IBOutlet weak var imagesLimitBackgroundView: UIView!
    @IBOutlet weak var imagesLimitSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var testServerButton: UIButton!
    @IBOutlet weak var realServerButton: UIButton!
    
    private var selectedSegmentIndex: Int = 0
    private var faceLivnessService: FaceIDService?
    private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupFaceIDService()
    }
    
    private func setupUI() {
        configureViews()
        configureActivityIndicator()
        configureSegmentedControl()
    }
    
    private func configureViews() {
        let customGreenColor = UIColor(red: 79.0/255.0, green: 150.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        
        imagesLimitBackgroundView.layer.cornerRadius = 10
        imagesLimitBackgroundView.layer.shadowColor = UIColor.black.cgColor
        imagesLimitBackgroundView.layer.shadowOpacity = 0.5
        imagesLimitBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 4)
        imagesLimitBackgroundView.layer.shadowRadius = 4
        
        testServerButton.backgroundColor = UIColor.clear
        testServerButton.setTitleColor(customGreenColor, for: .normal)
        testServerButton.layer.borderWidth = 0.5
        testServerButton.layer.borderColor = customGreenColor.cgColor
        testServerButton.layer.cornerRadius = 10
        
        realServerButton.backgroundColor = customGreenColor
        realServerButton.layer.borderWidth = 0.5
        realServerButton.layer.borderColor = customGreenColor.cgColor
        realServerButton.layer.cornerRadius = 10
    }
    
    private func configureActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .gray
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    private func configureSegmentedControl() {
        imagesLimitSegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    @objc private func segmentedControlValueChanged() {
        selectedSegmentIndex = imagesLimitSegmentedControl.selectedSegmentIndex
    }
    
    private func setupFaceIDService() {
        faceLivnessService = FaceIDService()
    }
    
    @IBAction func startServer(_ sender: UIButton) {
        let baseURL = sender == testServerButton ? "https://faceid.test.it.loc" : "https://faceid.it.loc"
        activityIndicator.startAnimating()
        
        faceLivnessService?.createFaceLivenessSession(baseURL: baseURL, auditImagesLimit: 1) { [weak self] result in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            self.handleSessionCreationResult(result)
        }
    }
    
    private func handleSessionCreationResult(_ result: Result<String, Error>) {
        switch result {
        case .success(let sessionId):
            print("Session created. Session ID: \(sessionId)")
            showSessionIDViewController(sessionID: sessionId)
        case .failure(let error):
            print("Session creation error: \(error.localizedDescription)")
            showAlert(message: "Reciving ID error")
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
//    private func showFaceDetectorViewController(sessionID: String) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let detectorVC = storyboard.instantiateViewController(withIdentifier: "FaceLivenessDetectorViewController") as? FaceLivenessDetectorViewController {
//            detectorVC.sessionID = sessionID
//            self.navigationController?.pushViewController(detectorVC, animated: true)
//        }
//    }
    
    private func showSessionIDViewController(sessionID: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let sessionIDVC = storyboard.instantiateViewController(withIdentifier: "SessionIDViewController") as? SessionIDViewController {
            sessionIDVC.sessionID = sessionID
            navigationController?.pushViewController(sessionIDVC, animated: true)
        }
    }

}

//
//  FaceLivenessDetectorViewController.swift
//  FaceLivenessDetector
//
//  Created by DN040801DDF on 25.09.2023.
//

import UIKit
import FaceLiveness
import SwiftUI
import AWSClientRuntime
import AWSPluginsCore

class FaceLivenessDetectorViewController: UIViewController {
    
    var sessionID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        configureFaceLivenessDetection()
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationBar() {
        self.title = "Face Detector"
    }
    
    private func configureFaceLivenessDetection() {
        let accessKey = "" // key
        let secretKey = "" // secret key
        
        let customCredentialsProvider = PbCredentialsProvider(
            accessKey: accessKey,
            secretKey: secretKey,
            sessionKey: nil
        )
        if let sessionID = self.sessionID {
            let faceLivenessSwiftUIView = FaceLivenessDetectorView(
                sessionID: sessionID,
                credentialsProvider: customCredentialsProvider,
                region: "eu-west-1",
                disableStartView: false, // Your configuration
                isPresented: .constant(true),
                onCompletion: { result in
                    switch result {
                    case .success:
                        print("Liveness successfully completed")
                    case .failure(let error):
                        print("Liveness error: \(error)")
                    }
                }
            )
            
            let hostingController = createHostingController(with: faceLivenessSwiftUIView)
            addHostingControllerAsChild(hostingController)
            configureConstraints(for: hostingController.view)
        }
    }
    
    private func createHostingController(with rootView: FaceLivenessDetectorView) -> UIHostingController<FaceLivenessDetectorView> {
        return UIHostingController(rootView: rootView)
    }
    
    private func addHostingControllerAsChild(_ hostingController: UIHostingController<FaceLivenessDetectorView>) {
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
    
    private func configureConstraints(for view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}

//
//  PBAWSCredentialsProvider.swift
//  FaceLivenessDetector
//
//  Created by DN040801DDF on 26.09.2023.
//

import Foundation
import AWSPluginsCore


struct PbAWSCredentials: AWSCredentials {
    let accessKeyId: String
    let secretAccessKey: String
}

class PbCredentialsProvider: NSObject, AWSCredentialsProvider {
    
    let accessKey: String
    let secretKey: String
    let sessionKey: String?

    init(accessKey: String, secretKey: String, sessionKey: String?) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.sessionKey = sessionKey
        super.init()
    }

    static func credentials(accessKey: String, secretKey: String, sessionKey: String?) -> PbCredentialsProvider {
        return PbCredentialsProvider(accessKey: accessKey, secretKey: secretKey, sessionKey: sessionKey)
    }

    func fetchAWSCredentials() async throws -> AWSPluginsCore.AWSCredentials {
        let awsCredentials = PbAWSCredentials(
            accessKeyId: self.accessKey,
            secretAccessKey: self.secretKey
        )
        return awsCredentials
    }
}

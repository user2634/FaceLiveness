//
//  FaceOnAPI.swift
//  FaceOn
//
//  Created by David Dahina on 9/19/23.
//

import Foundation
import Alamofire

class FaceIDService {
    
    private let sessionManager: Session
    
    init() {
        // session init
        sessionManager = Session(
            serverTrustManager: ServerTrustManager(evaluators: [
                "faceid.test.it.loc": DisabledTrustEvaluator(),
                "faceid.it.loc": DisabledTrustEvaluator()
            ]))
    }

    private let accessKeyId = ""
    private let accessSecretKey = ""
    
    // MARK: - Public Methods
    
    // create Face Liveness
    func createFaceLivenessSession(baseURL: String, auditImagesLimit: Int, completion: @escaping (Result<String, Error>) -> Void) {
        let endpoint = baseURL + "/liveness/CreateFaceLivenessSession"
        let parameters: [String: Any] = [
            "AuditImagesLimit": auditImagesLimit
        ]
        
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        addAuthorizationHeader(to: &headers)
        
        sessionManager.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let sessionData = value as? [String: Any],
                       let sessionId = sessionData["SessionId"] as? String {
                        completion(.success(sessionId))
                    } else {
                        completion(.failure(NSError(domain: "InvalidResponse", code: 0, userInfo: nil)))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    func getFaceLivenessSessionResults(baseURL: String, sessionId: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let endpoint = baseURL + "/liveness/GetFaceLivenessSessionResults"
        let parameters: [String: Any] = [
            "SessionId": sessionId
        ]

        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        addAuthorizationHeader(to: &headers)

        sessionManager.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let results = value as? [String: Any] {
                        completion(.success(results))
                    } else {
                        completion(.failure(NSError(domain: "InvalidResponse", code: 0, userInfo: nil)))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - Private Methods
    
    private func addAuthorizationHeader(to headers: inout HTTPHeaders) {
        let authHeader = "\(accessKeyId):\(accessSecretKey)"
        let base64AuthHeader = Data(authHeader.utf8).base64EncodedString()
        headers.add(name: "Authorization", value: "Basic \(base64AuthHeader)")
    }
}

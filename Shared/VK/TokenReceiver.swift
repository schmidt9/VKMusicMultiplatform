//
//  TokenReceiver.swift
//  VKMisicMultiplatform
//
//  Created by Alexander Kormanovsky on 27.03.2022.
//

import Foundation
import Alamofire

/// https://github.com/vodka2/vkaudiotoken-python/blob/5720e4cf77f5e1b20c3bf57f3df0717638a539e0/src/vkaudiotoken/TokenReceiverOfficial.py#L6
/// https://dev.vk.com/api/direct-auth#%D0%94%D0%B2%D1%83%D1%85%D1%84%D0%B0%D0%BA%D1%82%D0%BE%D1%80%D0%BD%D0%B0%D1%8F%20%D0%B0%D1%83%D1%82%D0%B5%D0%BD%D1%82%D0%B8%D1%84%D0%B8%D0%BA%D0%B0%D1%86%D0%B8%D1%8F
struct TokenReceiver {
    
    var url: URL!
    var userAgent: String
    
    init(login: String, password: String, validationCode: String = "", client: VKClient) {
        userAgent = client.userAgent
        
        let deviceId = generateRandomString()
        url = URL(string: URLQuery.buildURL(baseURL: "https://oauth.vk.com/token", params: [
            "grant_type" : "password",
            "client_id" : client.clientId,
            "client_secret" : client.clientSecret,
            "username" : login,
            "password" : password,
            "v" : "5.116",
            "lang" : "en",
            "scope" : "all",
            "device_id" : deviceId,
            "2fa_supported" : "1"
        ])!)
        
        if !validationCode.isEmpty {
            url = URL(string: URLQuery.buildURL(baseURL: url.absoluteString, params: ["code" : validationCode])!)
        }
    }
    
    func getToken(completion: @escaping (String?, Bool, String?, Bool?) -> Void) {
        let headers = HTTPHeaders(["User-Agent" : userAgent])
        
        AF.request(url, headers: headers).responseDecodable(of: AuthorizationResponse.self) { response in
            switch response.result {
            case let .success(authResponse):
                if let token = authResponse.access_token {
                    completion(token, false, nil, nil)
                    return
                }

                if let error = authResponse.error {
                    switch error {
                    case "need_validation":
                        completion(nil, true, authResponse.validation_sid, authResponse.validation_type == "2fa_app")
                    case "invalid_client":
                        print(error)
                    default:
                        print(error)
                    }
                }
                
                completion(nil, false, nil, nil)

            case let .failure(error):
                print(error)
            }
        }.responseString { response in
            print("Token request response:\n\(response)")
        }
    }
    
    private func generateRandomString() -> String {
        let elements = "0123456789abcdef"
        var result = ""
        
        for _ in 0..<elements.count {
            result += String(elements.randomElement()!)
        }
        
        return result
    }
    
}

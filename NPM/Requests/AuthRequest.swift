//
//  AuthRequest.swift
//  NPM
//
//  Created by Yaser Almasri on 14/08/25.
//

import SwiftUI
import Alamofire

class AuthRequest {
    public static func login(
        completionHandler: @escaping (_ success: Bool, _ auth: Auth?) -> Void
    ) {
        let userDefaults = UserDefaults.standard
        guard let baseUrl = userDefaults.string(forKey: "npm_server_url"),
              let username = userDefaults.string(forKey: "npm_username"),
                let password = userDefaults.string(forKey: "npm_password") else
        {
            completionHandler(false, nil)
            return
        }
        
        let url = URL(string: "\(baseUrl)/api/tokens")!
        let encoding = JSONEncoding.default
        AF.request(url, method: .post, parameters: ["identity": username, "secret": password], encoding: encoding)
            .responseDecodable(of: Auth.self) { response in
                switch response.result {
                case .success(let auth):
                    if let encoded = try? JSONEncoder().encode(auth) {
                        userDefaults.set(encoded, forKey: "npm_auth")
                    }
                    completionHandler(true, auth)
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(false, nil)
                }
            }
    }
}

extension DataRequest {
    func printError() -> Self {
        responseString { response in
            debugPrint("Error:", response)
        }
    }
}

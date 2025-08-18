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
        completionHandler: @escaping (_ success: Bool) -> Void
    ) {
        let userDefaults = UserDefaults.standard
        guard let baseUrl = userDefaults.string(forKey: "npm_server_url"),
              let username = userDefaults.string(forKey: "npm_username"),
                let password = userDefaults.string(forKey: "npm_password") else
        {
            completionHandler(false)
            return
        }
        
        let url = URL(string: "\(baseUrl)/api/tokens")!
        let encoding = JSONEncoding.default
        AF.request(url, method: .post, parameters: ["identity": username, "secret": password], encoding: encoding)
            .responseDecodable(of: Auth.self) { response in
                switch response.result {
                case .success(let auth):
                    AuthRequest.refresh(token: auth.token) { success in
                        completionHandler(success)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(false)
                }
            }
    }
    
    static public func refresh(
        token: String,
        completionHandler: @escaping (_ success: Bool) -> Void
    ) {
        let userDefaults = UserDefaults.standard
        guard let baseUrl = userDefaults.string(forKey: "npm_server_url") else {
            completionHandler(false)
            return
        }
        
        let url = URL(string: "\(baseUrl)/api/tokens")!
        AF.request(url, parameters: ["expiry": "5y"], headers: ["Authorization": "Bearer \(token)"])
            .responseDecodable(of: Auth.self) { response in
                switch response.result {
                case .success(let auth):
                    if let encoded = try? JSONEncoder().encode(auth) {
                        userDefaults.set(encoded, forKey: "npm_auth")
                    }
                    completionHandler(true)
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(false)
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

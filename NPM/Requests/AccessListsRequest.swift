//
//  AccessListsRequest.swift
//  NPM
//
//  Created by Yaser Almasri on 17/08/25.
//

import SwiftUI
import Alamofire

class AccessListsRequest {
    public static func fetch(
        completionHandler: @escaping (_ success: Bool, _ records: [AccessList]) -> Void
    ) {
        let userDefaults = UserDefaults.standard
        guard let baseUrl = userDefaults.string(forKey: "npm_server_url"),
              let auth_data = userDefaults.data(forKey: "npm_auth") else
        {
            completionHandler(false, [])
            return
        }
        guard let auth = try? JSONDecoder().decode(Auth.self, from: auth_data) else {
            return
        }
        
        let url = URL(string: "\(baseUrl)/api/nginx/access-lists?expand=items,clients")!
        let token = "Bearer \(auth.token)"
        AF.request(url, headers: ["Authorization": token])
            .responseDecodable(of: [AccessList].self) { response in
                switch response.result {
                case .success(let records):
                    completionHandler(true, records)
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(false, [])
                }
            }
    }
    
    public static func create(
        name: String,
        satisfyAny: Bool,
        passAuth: Bool,
        items: [[String: Any]],
        clients: [[String: Any]],
        completionHandler: @escaping (_ success: Bool, _ record: AccessList?) -> Void
    ) {
        let userDefaults = UserDefaults.standard
        guard let baseUrl = userDefaults.string(forKey: "npm_server_url"),
              let auth_data = userDefaults.data(forKey: "npm_auth") else {
            completionHandler(false, nil)
            return
        }
        guard let auth = try? JSONDecoder().decode(Auth.self, from: auth_data) else {
            return
        }
        
        let url = URL(string: "\(baseUrl)/api/nginx/access-lists")!
        let token = "Bearer \(auth.token)"
        let encoding = JSONEncoding.default
        let params: [String: Any] = [
            "name": name,
            "satisfy_any": satisfyAny,
            "pass_auth": passAuth,
            "items": items,
            "clients": clients,
        ]
        AF.request(url,method: .post, parameters: params, encoding: encoding, headers: ["Authorization": token])
            .responseDecodable(of: AccessList.self) { response in
                switch response.result {
                case .success(let record):
                    completionHandler(true, record)
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(false, nil)
                }
            }
    }
    
    public static func update(
        id: Int,
        name: String,
        satisfyAny: Bool,
        passAuth: Bool,
        items: [[String: Any]],
        clients: [[String: Any]],
        completionHandler: @escaping (_ success: Bool, _ record: AccessList?) -> Void
    ) {
        let userDefaults = UserDefaults.standard
        guard let baseUrl = userDefaults.string(forKey: "npm_server_url"),
              let auth_data = userDefaults.data(forKey: "npm_auth") else {
            completionHandler(false, nil)
            return
        }
        guard let auth = try? JSONDecoder().decode(Auth.self, from: auth_data) else {
            return
        }
        
        let url = URL(string: "\(baseUrl)/api/nginx/access-lists/\(id)")!
        let token = "Bearer \(auth.token)"
        let encoding = JSONEncoding.default
        let params: [String: Any] = [
            "name": name,
            "satisfy_any": satisfyAny,
            "pass_auth": passAuth,
            "items": items,
            "clients": clients,
        ]
        AF.request(url,method: .put, parameters: params, encoding: encoding, headers: ["Authorization": token])
            .responseDecodable(of: AccessList.self) { response in
                switch response.result {
                case .success(let record):
                    completionHandler(true, record)
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(false, nil)
                }
            }
    }
}

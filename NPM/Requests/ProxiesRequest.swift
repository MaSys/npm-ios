//
//  ProxiesRequest.swift
//  NPM
//
//  Created by Yaser Almasri on 14/08/25.
//

import SwiftUI
import Alamofire

class ProxiesRequest {
    public static func fetch(
        completionHandler: @escaping (_ success: Bool, _ records: [Proxy]) -> Void
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
        
        let url = URL(string: "\(baseUrl)/api/nginx/proxy-hosts")!
        let token = "Bearer \(auth.token)"
        AF.request(url, headers: ["Authorization": token])
            .responseDecodable(of: [Proxy].self) { response in
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
        schema: String,
        host: String,
        port: Int,
        domains: [String],
        completionHandler: @escaping (_ success: Bool, _ record: Proxy?) -> Void
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
        
        let url = URL(string: "\(baseUrl)/api/nginx/proxy-hosts")!
        let token = "Bearer \(auth.token)"
        let encoding = JSONEncoding.default
        let params: [String: Any] = [
            "domain_names": domains,
            "forward_scheme": schema,
            "forward_host": host,
            "forward_port": port
        ]
        AF.request(url,method: .post, parameters: params, encoding: encoding, headers: ["Authorization": token])
            .responseDecodable(of: Proxy.self) { response in
                switch response.result {
                case .success(let record):
                    completionHandler(true, record)
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(false, nil)
                }
            }
    }
    
    public static func updateSSL(
        id: Int,
        cert_id: Int,
        completionHandler: @escaping (_ success: Bool) -> Void
    ) {
        let userDefaults = UserDefaults.standard
        guard let baseUrl = userDefaults.string(forKey: "npm_server_url"),
              let auth_data = userDefaults.data(forKey: "npm_auth") else {
            completionHandler(false)
            return
        }
        guard let auth = try? JSONDecoder().decode(Auth.self, from: auth_data) else {
            return
        }
        
        let url = URL(string: "\(baseUrl)/api/nginx/proxy-hosts/\(id)")!
        let token = "Bearer \(auth.token)"
        let encoding = JSONEncoding.default
        let params: [String: Any] = ["certificate_id": cert_id]
        AF.request(url, method: .put, parameters: params, encoding: encoding, headers: ["Authorization": token])
            .printError()
            .responseDecodable(of: Proxy.self) { response in
                print(response)
                switch response.result {
                case .success(let record):
                    completionHandler(true)
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(false)
                }
            }
    }
}

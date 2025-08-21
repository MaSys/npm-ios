//
//  RedirectionsRequest.swift
//  NPM
//
//  Created by Yaser Almasri on 19/08/25.
//

import SwiftUI
import Alamofire

class RedirectionsRequest {
    public static func fetch(
        completionHandler: @escaping (_ success: Bool, _ records: [Redirection]) -> Void
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
        
        let url = URL(string: "\(baseUrl)/api/nginx/redirection-hosts")!
        let token = "Bearer \(auth.token)"
        AF.request(url, headers: ["Authorization": token])
            .responseDecodable(of: [Redirection].self) { response in
                switch response.result {
                case .success(let records):
                    completionHandler(true, records)
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(false, [])
                }
            }
    }
    
    // TODO: Toggle is not permitted/implemented in the API
    public static func toggle(
        id: Int,
        enabled: Bool,
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
        
        let url = URL(string: "\(baseUrl)/api/nginx/redirection-hosts/\(id)")!
        let token = "Bearer \(auth.token)"
        let encoding = JSONEncoding.default
        let params: [String: Any] = [
            "enabled": enabled
        ]
        AF.request(url, method: .put, parameters: params, encoding: encoding, headers: ["Authorization": token])
            .printError()
            .responseDecodable(of: Redirection.self) { response in
                print(response)
                switch response.result {
                case .success(_):
                    completionHandler(true)
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(false)
                }
            }
    }
    
    public static func create(
        scheme: String,
        forwardDomain: String,
        httpCode: Int,
        domains: [String],
        preservePath: Bool,
        blockCommonExploit: Bool,
        completionHandler: @escaping (_ success: Bool, _ record: Redirection?) -> Void
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
        
        let url = URL(string: "\(baseUrl)/api/nginx/redirection-hosts")!
        let token = "Bearer \(auth.token)"
        let encoding = JSONEncoding.default
        let params: [String: Any] = [
            "domain_names": domains,
            "forward_domain_name": forwardDomain,
            "forward_scheme": scheme,
            "preserve_path": preservePath,
            "block_exploits": blockCommonExploit,
            "forward_http_code": httpCode
        ]
        AF.request(url,method: .post, parameters: params, encoding: encoding, headers: ["Authorization": token])
            .printError()
            .responseDecodable(of: Redirection.self) { response in
                print(response)
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
        forceSSL: Bool,
        httpSupport: Bool,
        hsts: Bool,
        hstsSubdomains: Bool,
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
        
        let url = URL(string: "\(baseUrl)/api/nginx/redirection-hosts/\(id)")!
        let token = "Bearer \(auth.token)"
        let encoding = JSONEncoding.default
        let params: [String: Any] = [
            "certificate_id": cert_id,
            "ssl_forced": forceSSL,
            "hsts_enabled": hsts,
            "hsts_subdomains": hstsSubdomains,
            "http2_support": httpSupport
        ]
        AF.request(url, method: .put, parameters: params, encoding: encoding, headers: ["Authorization": token])
            .responseDecodable(of: Redirection.self) { response in
                switch response.result {
                case .success(_):
                    completionHandler(true)
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(false)
                }
            }
    }
}

//
//  StreamsRequest.swift
//  NPM
//
//  Created by Yaser Almasri on 13/09/25.
//

import SwiftUI
import Alamofire

class StreamsRequest {
    public static func fetch(
        completionHandler: @escaping (_ success: Bool, _ records: [Stream]) -> Void
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
        
        let url = URL(string: "\(baseUrl)/api/nginx/streams")!
        let token = "Bearer \(auth.token)"
        AF.request(url, headers: ["Authorization": token])
            .responseDecodable(of: [Stream].self) { response in
                switch response.result {
                case .success(let records):
                    completionHandler(true, records)
                case .failure(let error):
                    print(response)
                    print(error.localizedDescription)
                    completionHandler(false, [])
                }
            }
    }
    
    public static func create(
        incomingPort: Int,
        forwardHost: String,
        forwardPort: Int,
        tcpForwarding: Bool,
        udpForwarding: Bool,
        certificateId: Int,
        completionHandler: @escaping (_ success: Bool, _ record: Stream?) -> Void
    ) {
        let userDefaults = UserDefaults.standard
        guard let baseUrl = userDefaults.string(forKey: "npm_server_url"),
              let auth_data = userDefaults.data(forKey: "npm_auth") else
        {
            completionHandler(false, nil)
            return
        }
        guard let auth = try? JSONDecoder().decode(Auth.self, from: auth_data) else {
            return
        }
        
        let url = URL(string: "\(baseUrl)/api/nginx/streams")!
        let token = "Bearer \(auth.token)"
        let encoding = JSONEncoding.default
        AF.request(url, method: .post, parameters: [
            "incoming_port": incomingPort,
            "forwarding_host": forwardHost,
            "forwarding_port": forwardPort,
            "tcp_forwarding": tcpForwarding,
            "udp_forwarding": udpForwarding,
            "certificate_id": certificateId
        ], encoding: encoding, headers: ["Authorization": token])
        .printError()
            .responseDecodable(of: Stream.self) { response in
                switch response.result {
                case .success(let record):
                    completionHandler(true, record)
                case .failure(let error):
                    print(response)
                    print(error.localizedDescription)
                    completionHandler(false, nil)
                }
            }
    }
    
    public static func update(
        id: Int,
        incomingPort: Int,
        forwardHost: String,
        forwardPort: Int,
        tcpForwarding: Bool,
        udpForwarding: Bool,
        certificateId: Int,
        completionHandler: @escaping (_ success: Bool, _ record: Stream?) -> Void
    ) {
        let userDefaults = UserDefaults.standard
        guard let baseUrl = userDefaults.string(forKey: "npm_server_url"),
              let auth_data = userDefaults.data(forKey: "npm_auth") else
        {
            completionHandler(false, nil)
            return
        }
        guard let auth = try? JSONDecoder().decode(Auth.self, from: auth_data) else {
            return
        }
        
        let url = URL(string: "\(baseUrl)/api/nginx/streams/\(id)")!
        let token = "Bearer \(auth.token)"
        let encoding = JSONEncoding.default
        AF.request(url, method: .put, parameters: [
            "incoming_port": incomingPort,
            "forwarding_host": forwardHost,
            "forwarding_port": forwardPort,
            "tcp_forwarding": tcpForwarding,
            "udp_forwarding": udpForwarding,
            "certificate_id": certificateId
        ], encoding: encoding, headers: ["Authorization": token])
            .responseDecodable(of: Stream.self) { response in
                switch response.result {
                case .success(let record):
                    completionHandler(true, record)
                case .failure(let error):
                    print(response)
                    print(error.localizedDescription)
                    completionHandler(false, nil)
                }
            }
    }
    
    public static func delete(
        id: Int,
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
        
        let url = URL(string: "\(baseUrl)/api/nginx/streams/\(id)")!
        let token = "Bearer \(auth.token)"
        let encoding = JSONEncoding.default
        AF.request(url,method: .delete, encoding: encoding, headers: ["Authorization": token])
            .responseDecodable(of: Bool.self) { response in
                switch response.result {
                case .success(let success):
                    completionHandler(success)
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(false)
                }
            }
    }
}

//
//  CertsRequest.swift
//  NPM
//
//  Created by Yaser Almasri on 15/08/25.
//

import SwiftUI
import Alamofire

class CertsRequest {
    public static func fetch(
        completionHandler: @escaping (_ success: Bool, _ records: [Cert]) -> Void
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
        
        let url = URL(string: "\(baseUrl)/api/nginx/certificates?expand=proxy_hosts,dead_hosts,redirection_hosts")!
        let token = "Bearer \(auth.token)"
        AF.request(url, headers: ["Authorization": token])
            .responseDecodable(of: [Cert].self) { response in
                switch response.result {
                case .success(let records):
                    completionHandler(true, records)
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(false, [])
                }
            }
    }
}

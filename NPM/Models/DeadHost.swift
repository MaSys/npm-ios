//
//  DeadHost.swift
//  NPM
//
//  Created by Yaser Almasri on 27/08/25.
//

struct DeadHost: Host, Decodable {
    var id: Int
    var created_on: String
    var modified_on: String
    var owner_user_id: Int
    var domain_names: [String]
    var certificate_id: Int
    var ssl_forced: Bool
    var advanced_config: String
    var meta: Meta
    var http2_support: Bool
    var enabled: Bool
    var hsts_enabled: Bool
    var hsts_subdomains: Bool
}

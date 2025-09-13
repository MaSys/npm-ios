//
//  Redirection.swift
//  NPM
//
//  Created by Yaser Almasri on 19/08/25.
//

struct Redirection: Host, SSLHost, Decodable {
    var id: Int
    var created_on: String
    var modified_on: String
    var owner_user_id: Int
    var domain_names: [String]
    var forward_domain_name: String
    var preserve_path: Bool
    var certificate_id: Int
    var ssl_forced: Bool
    var block_exploits: Bool
    var advanced_config: String
    var meta: Meta
    var http2_support: Bool
    var enabled: Bool
    var hsts_enabled: Bool
    var hsts_subdomains: Bool
    var forward_scheme: String
    var forward_http_code: Int
}

extension Redirection {
    public static func fake() -> Redirection {
        return Redirection(
            id: 1,
            created_on: "2025-08-19 20:54:57",
            modified_on: "2025-08-19 20:54:57",
            owner_user_id: 1,
            domain_names: ["jellyfin.home"],
            forward_domain_name: "jellyfin.almasri.online",
            preserve_path: true,
            certificate_id: 0,
            ssl_forced: false,
            block_exploits: false,
            advanced_config: "",
            meta: Meta(),
            http2_support: false,
            enabled: true,
            hsts_enabled: false,
            hsts_subdomains: false,
            forward_scheme: "https",
            forward_http_code: 308
        )
    }
}

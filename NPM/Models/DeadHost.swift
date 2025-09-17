//
//  DeadHost.swift
//  NPM
//
//  Created by Yaser Almasri on 27/08/25.
//

struct DeadHost: Host, SSLHost, Decodable {
    var id: Int
    var created_on: String
    var modified_on: String
    var owner_user_id: Int
    var domain_names: [String]
    var certificate_id: Int
    var ssl_forced: Bool
    var advanced_config: String?
    var meta: Meta
    var http2_support: Bool
    var enabled: Bool
    var hsts_enabled: Bool
    var hsts_subdomains: Bool
}

extension DeadHost {
    public static func fake() -> DeadHost {
        return DeadHost(
            id: 1,
            created_on: "2025-08-25 23:33:10",
            modified_on: "2025-08-27 20:29:16",
            owner_user_id: 1,
            domain_names: ["test.home"],
            certificate_id: 51,
            ssl_forced: false,
            advanced_config: "",
            meta: Meta(
                letsencrypt_agree: false,
                dns_challenge: false,
                nginx_online: true
            ),
            http2_support: false,
            enabled: true,
            hsts_enabled: false,
            hsts_subdomains: false
        )
    }
}

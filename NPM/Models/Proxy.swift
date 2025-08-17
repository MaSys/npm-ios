//
//  Proxy.swift
//  NPM
//
//  Created by Yaser Almasri on 14/08/25.
//

struct ProxyMeta: Decodable {
    var letsencrypt_agree: Bool?
    var dns_challenge: Bool?
    var nginx_online: Bool?
    var nginx_err: String?
}

struct Proxy: Decodable {
    var id: Int
    var created_on: String
    var modified_on: String
    var owner_user_id: Int
    var domain_names: [String]
    var forward_host: String
    var forward_port: Int
    var access_list_id: Int
    var certificate_id: Int
    var ssl_forced: Bool
    var caching_enabled: Bool
    var block_exploits: Bool
    var advanced_config: String
    var meta: ProxyMeta
    var allow_websocket_upgrade: Bool
    var http2_support: Bool
    var forward_scheme: String
    var enabled: Bool
    var locations: [String]?
    var hsts_enabled: Bool
    var hsts_subdomains: Bool
}

extension Proxy {
    public static func fake() -> Proxy {
        return Proxy(
            id: 11,
            created_on: "2025-04-05 00:47:21",
            modified_on: "2025-07-20 14:45:14",
            owner_user_id: 1,
            domain_names: [
                "wallos.home"
            ],
            forward_host: "192.168.68.251",
            forward_port: 5010,
            access_list_id: 0,
            certificate_id: 0,
            ssl_forced: false,
            caching_enabled: false,
            block_exploits: false,
            advanced_config: "",
            meta: ProxyMeta(
                letsencrypt_agree: false,
                dns_challenge: false,
                nginx_online: true,
                nginx_err: nil
            ),
            allow_websocket_upgrade: false,
            http2_support: false,
            forward_scheme: "http",
            enabled: true,
            locations: [],
            hsts_enabled: false,
            hsts_subdomains: false
        )
    }
}

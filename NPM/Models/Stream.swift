//
//  Stream.swift
//  NPM
//
//  Created by Yaser Almasri on 13/09/25.
//

struct Stream: Host, Decodable {
    var id: Int
    var created_on: String
    var modified_on: String
    var owner_user_id: Int
    var incoming_port: Int
    var forwarding_host: String
    var forwarding_port: Int
    var tcp_forwarding: Bool
    var udp_forwarding: Bool
    var meta: Meta
    var enabled: Bool
    var certificate_id: Int
}

extension Stream {
    public static func fake() -> Stream {
        return Stream(
            id: 1,
            created_on: "2024-10-09T02:33:45.000Z",
            modified_on: "2024-10-09T02:33:45.000Z",
            owner_user_id: 1,
            incoming_port: 9090,
            forwarding_host: "router.internal",
            forwarding_port: 80,
            tcp_forwarding: true,
            udp_forwarding: false,
            meta: Meta(
                letsencrypt_agree: false,
                dns_challenge: false,
                nginx_online: true,
                nginx_err: nil
            ),
            enabled: true,
            certificate_id: 0
        )
    }
}

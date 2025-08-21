//
//  Meta.swift
//  NPM
//
//  Created by Yaser Almasri on 19/08/25.
//

struct Meta: Decodable {
    var letsencrypt_email: String?
    var letsencrypt_agree: Bool?
    var dns_challenge: Bool?
    var nginx_online: Bool?
    var nginx_err: String?
}

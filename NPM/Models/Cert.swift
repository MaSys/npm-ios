//
//  Cert.swift
//  NPM
//
//  Created by Yaser Almasri on 15/08/25.
//

struct CertMeta: Decodable {
    var letsencrypt_email: String
    var dns_challenge: Bool
    var dns_provider: String
    var dns_provider_credentials: String
    var letsencrypt_agree: Bool
}

struct Cert: Decodable {
    var id: Int
    var created_on: String
    var modified_on: String
    var owner_user_id: Int
    var provider: String
    var nice_name: String
    var domain_names: [String]
    var expires_on: String
    var meta: CertMeta
}

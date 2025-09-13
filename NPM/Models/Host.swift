//
//  Host.swift
//  NPM
//
//  Created by Yaser Almasri on 19/08/25.
//

protocol Host {
    var id: Int { get }
    var meta: Meta { get }
    var enabled: Bool { get }
}

protocol SSLHost {
    var id: Int { get }
    var certificate_id: Int { get }
    var ssl_forced: Bool { get }
    var http2_support: Bool { get }
    var hsts_enabled: Bool { get }
    var hsts_subdomains: Bool { get }
}

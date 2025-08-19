//
//  AccessList.swift
//  NPM
//
//  Created by Yaser Almasri on 17/08/25.
//

struct AccessListMeta: Decodable {
}

struct AccessList: Decodable {
    var id: Int
    var created_on: String
    var modified_on: String
    var owner_user_id: Int
    var name: String
    var meta: AccessListMeta
    var satisfy_any: Bool
    var pass_auth: Bool
    var proxy_host_count: Int
}

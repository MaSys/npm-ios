//
//  AccessList.swift
//  NPM
//
//  Created by Yaser Almasri on 17/08/25.
//

struct AccessList: Decodable {
    var id: Int
    var created_on: String
    var modified_on: String
    var owner_user_id: Int
    var name: String
    var meta: Meta
    var satisfy_any: Bool
    var pass_auth: Bool
    var proxy_host_count: Int
    
    var clients: [ALClient]
    var items: [ALItem]
}

struct ALItem: Decodable {
    var id: Int
    var created_on: String
    var modified_on: String
    var access_list_id: Int
    var hint: String
    var meta: Meta
    var password: String
    var username: String
}

struct ALClient: Decodable {
    var id: Int
    var created_on: String
    var modified_on: String
    var access_list_id: Int
    var address: String
    var directive: String
    var meta: Meta
}

//
//  Cert.swift
//  NPM
//
//  Created by Yaser Almasri on 15/08/25.
//

struct Cert: Decodable {
    var id: Int
    var created_on: String
    var modified_on: String
    var owner_user_id: Int
    var provider: String
    var nice_name: String
    var domain_names: [String]
    var expires_on: String
    var meta: Meta
    
    var proxy_hosts: [Proxy]
    var redirection_hosts: [Redirection]
    var dead_hosts: [DeadHost]
    
    
    var inUse: Bool {
        if self.proxy_hosts.count != 0 {
            return true
        }
        
        if self.redirection_hosts.count != 0 {
            return true
        }
        
        if self.dead_hosts.count != 0 {
            return true
        }
        
        return false
    }
}

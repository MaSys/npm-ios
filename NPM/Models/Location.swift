//
//  Location.swift
//  NPM
//
//  Created by Yaser Almasri on 19/08/25.
//

import Foundation

struct Location: Codable {
    var id: Int
    var path: String
    var forward_scheme: String
    var forward_host: String
    var forward_port: Int
    var forward_path: String?
    var advanced_config: String
    
    enum CodingKeys: CodingKey {
        case path
        case forward_scheme
        case forward_host
        case forward_port
        case forward_path
        case advanced_config
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = Int.random(in: 1000..<9999)
        self.path = try container.decode(String.self, forKey: .path)
        self.forward_scheme = try container.decode(String.self, forKey: .forward_scheme)
        self.forward_host = try container.decode(String.self, forKey: .forward_host)
        self.forward_port = try container.decode(Int.self, forKey: .forward_port)
        self.forward_path = try container.decodeIfPresent(String.self, forKey: .forward_path)
        self.advanced_config = try container.decode(String.self, forKey: .advanced_config)
    }
    
    init(path: String, forward_scheme: String, forward_host: String, forward_port: Int, advanced_config: String) {
        self.id = Int.random(in: 1000..<9999)
        self.path = path
        self.forward_scheme = forward_scheme
        self.forward_host = forward_host
        self.forward_port = forward_port
        self.advanced_config = advanced_config
    }
}

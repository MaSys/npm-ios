//
//  CertDns.swift
//  NPM
//
//  Created by Yaser Almasri on 26/08/25.
//

import SwiftUI

struct Plugin: Decodable {
    var name: String
    var package_name: String
    var version: String
    var dependencies: String
    var credentials: String
    var full_plugin_name: String
}



func loadPlugins(from filename: String) -> [String: Plugin]? {
    guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
        print("Failed to locate \(filename) in bundle.")
        return nil
    }

    do {
        let data = try Data(contentsOf: url)
        let plugins = try JSONDecoder().decode([String: Plugin].self, from: data)
        return plugins
    } catch {
        print("Error loading or decoding \(filename): \(error)")
        return nil
    }
}

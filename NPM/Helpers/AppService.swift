//
//  AppService.swift
//  NPM
//
//  Created by Yaser Almasri on 13/08/25.
//

import SwiftUI

class AppService: ObservableObject {
    
    public static var shared = AppService()
    
    @AppStorage("npm_server_url") var pangolinServerUrl: String = ""
    
    @Published var plugins: [String: Plugin] = [:]
    @Published var certs: [Cert] = []
    @Published var proxies: [Proxy] = []
    @Published var accessLists: [AccessList] = []
    @Published var redirections: [Redirection] = []
    @Published var streams: [Stream] = []
    
    public func fetchCerts() {
        CertsRequest.fetch { success, records in
            self.certs = records
        }
    }
    
    public func fetchProxies() {
        ProxiesRequest.fetch { success, records in
            self.proxies = records
        }
    }
    
    public func fetchAccessLists() {
        AccessListsRequest.fetch { success, records in
            self.accessLists = records
        }
    }
    
    public func fetchRedirections() {
        RedirectionsRequest.fetch { success, records in
            self.redirections = records
        }
    }
    
    public func fetchStreams() {
        StreamsRequest.fetch { success, records in
            self.streams = records
        }
    }
    
    public func setPlugins() {
        if let plugins = loadPlugins(from: "certbot-dns-plugins.json") {
            self.plugins = plugins
        } else {
            print("Failed to load plugins.")
        }
    }
}

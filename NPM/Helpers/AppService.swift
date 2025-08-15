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
    
    @Published var certs: [Cert] = []
    
    public func fetchCerts() {
        CertsRequest.fetch { success, records in
            self.certs = records
        }
    }
}

//
//  NPMApp.swift
//  NPM
//
//  Created by Yaser Almasri on 13/08/25.
//

import SwiftUI

@main
struct NPMApp: App {
    
    @StateObject var appService = AppService.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(self.appService)
        }
    }
}

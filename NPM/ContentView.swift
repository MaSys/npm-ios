//
//  ContentView.swift
//  NPM
//
//  Created by Yaser Almasri on 13/08/25.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appService: AppService
    
    var body: some View {
        TabView {
            DashboardView()
                .environmentObject(appService)
                .tabItem {
                    Label("DASHBOARD", systemImage: "house")
                }
            
            ProxiesView()
                .environmentObject(appService)
                .tabItem {
                    Label("PROXY", systemImage: "bolt.horizontal")
                }
            
            RedirectionsView()
                .environmentObject(appService)
                .tabItem {
                    Label("REDIRECTION", systemImage: "arrow.trianglehead.branch")
                    
                }
            
            SettingsView()
                .environmentObject(appService)
                .tabItem {
                    Label("SETTINGS", systemImage: "gear")
                }
        }
        .onAppear {
            self.appService.fetchCerts()
        }
    }
}

#Preview {
    ContentView()
}

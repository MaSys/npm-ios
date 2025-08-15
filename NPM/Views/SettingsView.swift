//
//  SettingsView.swift
//  NPM
//
//  Created by Yaser Almasri on 13/08/25.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("npm_server_url") var npmServerUrl: String = ""
    @AppStorage("npm_username") var npmUsername: String = ""
    @AppStorage("npm_password") var npmPassword: String = ""
    
    @EnvironmentObject var appService: AppService
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("")) {
                    NavigationLink(destination: InstanceView()) {
                        VStack(alignment: .leading) {
                            Text("INSTANCE")
                            if !self.npmServerUrl.isEmpty {
                                Text(self.npmServerUrl)
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 14))
                            }
                        }
                    }//Link
                }//Section
                
                Section {
                    NavigationLink {
                        EmptyView()
                    } label: {
                        Text("STREAMS")
                    }
                    
                    NavigationLink {
                        EmptyView()
                    } label: {
                        Text("404_HOSTS")
                    }
                }//Section
                
                Section {
                    NavigationLink {
                        EmptyView()
                    } label: {
                        Text("CERTIFICATIONS")
                    }
                    NavigationLink {
                        EmptyView()
                    } label: {
                        Text("ACCESS_LISTS")
                    }
                }//Section
            }//List
            .navigationTitle(Text("SETTINGS"))
        }//NavStack
    }
}

#Preview {
    SettingsView()
}

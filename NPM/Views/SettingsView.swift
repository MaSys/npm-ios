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
                    NavigationLink {
                        InstanceView()
                            .environmentObject(AppService.shared)
                    } label: {
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
                    HStack {
                        Text("STREAMS")
                        Spacer()
                        Text("COMING_SOON")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("404_HOSTS")
                        Spacer()
                        Text("COMING_SOON")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
//                    NavigationLink {
//                        EmptyView()
//                    } label: {
//                        Text("STREAMS")
//                    }
//                    NavigationLink {
//                        EmptyView()
//                    } label: {
//                        Text("404_HOSTS")
//                    }
                }//Section
                
                Section {
                    HStack {
                        Text("CERTIFICATIONS")
                        Spacer()
                        Text("COMING_SOON")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("ACCESS_LISTS")
                        Spacer()
                        Text("COMING_SOON")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
//                    NavigationLink {
//                        EmptyView()
//                    } label: {
//                        Text("CERTIFICATIONS")
//                    }
//                    NavigationLink {
//                        EmptyView()
//                    } label: {
//                        Text("ACCESS_LISTS")
//                    }
                }//Section
                
                Section {
                    Button(action: {
                        let email = "support@masys.mx"
                        let subject = "Support / Feedback"
                        let body = getDeviceAndAppInfo().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

                        if let url = URL(string: "mailto:\(email)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&body=\(body)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("SUPPORT_FEEDBACK")
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

func getDeviceAndAppInfo() -> String {
    let device = UIDevice.current
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    let systemName = device.systemName
    let systemVersion = device.systemVersion
    let model = device.model

    return """
    --- Device / App Info ---
    App Version: \(appVersion)
    Build Number: \(buildNumber)
    Device Model: \(model)
    OS: \(systemName) \(systemVersion)
    """
}

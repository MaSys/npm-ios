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

    @State private var connectivityStatus: InstanceConnectivityStatus?
    @State private var isCheckingConnectivity = false
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("")) {
                    HStack {
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
                                    connectivityStatusView
                                }
                            }
                        }

                        if !self.npmServerUrl.isEmpty {
                            Button {
                                self.checkConnectivity()
                            } label: {
                                Image(systemName: "arrow.clockwise")
                            }
                            .accessibilityLabel(Text("RETRY"))
                            .buttonStyle(.borderless)
                            .disabled(self.isCheckingConnectivity)
                        }
                    }
                }//Section
                
                Section {
                    NavigationLink {
                        StreamsView()
                            .environmentObject(self.appService)
                    } label: {
                        Text("STREAMS")
                    }
                    NavigationLink {
                        DeadHostsView()
                            .environmentObject(self.appService)
                    } label: {
                        Text("404_HOSTS")
                    }
                }//Section
                
                Section {
                    NavigationLink {
                        CertsView()
                            .environmentObject(self.appService)
                    } label: {
                        Text("CERTIFICATIONS")
                    }
                    NavigationLink {
                        AccessListsView()
                            .environmentObject(self.appService)
                    } label: {
                        Text("ACCESS_LISTS")
                    }
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
            .onAppear {
                self.checkConnectivity()
            }
        }//NavStack
    }

    @ViewBuilder
    private var connectivityStatusView: some View {
        HStack(spacing: 5) {
            if self.isCheckingConnectivity {
                ProgressView()
                    .controlSize(.small)
                Text("INSTANCE_CHECKING")
            } else {
                switch self.connectivityStatus {
                case .connected:
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Text("INSTANCE_CONNECTED")
                case .authenticationFailed:
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundStyle(.red)
                    Text("INSTANCE_AUTHENTICATION_FAILED")
                case .serverUnavailable:
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundStyle(.red)
                    Text("INSTANCE_SERVER_UNAVAILABLE")
                case nil:
                    EmptyView()
                }
            }
        }
        .foregroundStyle(.secondary)
        .font(.system(size: 14))
    }

    private func checkConnectivity() {
        guard !self.npmServerUrl.isEmpty else {
            self.connectivityStatus = nil
            self.isCheckingConnectivity = false
            return
        }

        self.isCheckingConnectivity = true
        InstanceConnectivityRequest.check { status in
            self.connectivityStatus = status
            self.isCheckingConnectivity = false
        }
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

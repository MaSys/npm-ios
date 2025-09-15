//
//  InstanceView.swift
//  NPM
//
//  Created by Yaser Almasri on 14/08/25.
//

import SwiftUI
import Network

struct InstanceView: View {
    
    @AppStorage("npm_server_url") var npmServerUrl: String = ""
    @AppStorage("npm_username") var npmUsername: String = ""
    @AppStorage("npm_password") var npmPassword: String = ""
    
    @EnvironmentObject var appService: AppService
    @Environment(\.dismiss) var dismiss
    
    @State private var serverUrl = ""
    @State private var username = ""
    @State private var password = ""
    @State private var connectionError: Bool = false
    @State private var isLoading: Bool = false
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("SERVER_URL")
                    TextField("SERVER_URL", text: $serverUrl)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.URL)
                        .textContentType(.URL)
                        .textInputAutocapitalization(.none)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                }
                
                HStack {
                    Text("USERNAME")
                    TextField("USERNAME", text: $username)
                        .multilineTextAlignment(.trailing)
                        .textInputAutocapitalization(.none)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                }
                
                HStack {
                    Text("PASSWORD")
                    SecureField("PASSWORD", text: $password)
                        .multilineTextAlignment(.trailing)
                }
                
                if connectionError == true {
                    Text("ERROR_CONNECTING_TO_SERVER")
                        .foregroundStyle(.red)
                        .font(.system(size: 14))
                }
            }
        }
        .onAppear {
            self.serverUrl = self.npmServerUrl
            self.username = self.npmUsername
            self.password = self.npmPassword
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if self.isLoading == false {
                        self.save()
                    }
                } label: {
                    Text("SAVE")
                }
            }
        }
    }
    
    private func save() {
        if self.serverUrl.isEmpty || self.username.isEmpty || self.password.isEmpty {
            return
        }
        
        guard let url = URL(string: self.serverUrl), url.host != nil else {
            self.isLoading = false
            self.connectionError = true
            return
        }
        
        self.isLoading = true
        self.connectionError = false
        self.npmServerUrl = self.serverUrl
        self.npmUsername = self.username
        self.npmPassword = self.password
        
        AuthRequest.login { success in
            self.isLoading = false
            if success {
                self.dismiss()
            } else {
                self.connectionError = true
            }
        }
    }
}

#Preview {
    InstanceView()
}

//
//  ProxyEditView.swift
//  NPM
//
//  Created by Yaser Almasri on 20/08/25.
//

import SwiftUI

struct ProxyEditView: View {
    
    var proxy: Proxy
    
    @EnvironmentObject var appService: AppService
    @Environment(\.dismiss) var dismiss
    
    @State private var scheme: String = "http"
    @State private var host: String = ""
    @State private var port: String = ""
    @State private var domain: String = ""
    @State private var domains: [String] = []
    
    var validForm: Bool {
        if self.host.isEmpty || self.port.isEmpty || self.domains.count == 0 {
            return false
        }
        
        return true
    }
    
    var body: some View {
        Form {
            Section {
                Picker("SCHEME", selection: $scheme) {
                    Text("http")
                        .tag("http")
                    Text("https")
                        .tag("https")
                }//Picker
                .pickerStyle(.segmented)
                VStack(alignment: .leading) {
                    Text("FORWARD_HOST")
                    TextField("FORWARD_HOST", text: $host)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .keyboardType(.URL)
                }//HStack
                HStack {
                    Text("FORWARD_PORT")
                    TextField("FORWARD_PORT", text: $port)
                        .multilineTextAlignment(.trailing)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .keyboardType(.numberPad)
                }//HStack
            }//Section
            
            Section(header: Text("DOMAIN_NAMES")) {
                HStack {
                    TextField("my.domain.local", text: $domain)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .keyboardType(.URL)
                    Divider()
                    Button("ADD") {
                        if !self.domain.isEmpty {
                            self.domains.append(self.domain)
                            self.domain = ""
                        }
                    }
                    .disabled(self.domain.isEmpty)
                }//HStack
                
                List {
                    ForEach(self.domains, id: \.self) { dom in
                        Text(dom)
                    }
                    .onDelete { index in
                        self.domains.remove(atOffsets: index)
                    }
                }
            }//Section
            .textCase(nil)
        }
        .onAppear {
            self.domains = self.proxy.domain_names
            self.scheme = self.proxy.forward_scheme
            self.host = self.proxy.forward_host
            self.port = String(self.proxy.forward_port)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("SAVE") {
                    self.save()
                }
                .disabled(!self.validForm)
            }
        }
    }
    
    private func save() {
        if !self.validForm { return }
        
        ProxiesRequest.update(
            id: self.proxy.id,
            scheme: self.scheme,
            host: self.host,
            port: Int(self.port)!,
            domains: self.domains
        ) { success, record in
            if success {
                self.appService.fetchProxies()
                self.dismiss()
            }
        }
    }
}

#Preview {
    ProxyEditView(proxy: Proxy.fake())
}

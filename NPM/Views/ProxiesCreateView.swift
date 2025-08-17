//
//  ProxiesCreateView.swift
//  NPM
//
//  Created by Yaser Almasri on 16/08/25.
//

import SwiftUI

struct ProxiesCreateView: View {
    
    @EnvironmentObject var appService: AppService
    @Environment(\.dismiss) var dismiss
    
    @State private var schema: String = "http"
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
                Picker("SCHEMA", selection: $schema) {
                    Text("http")
                        .tag("http")
                    Text("https")
                        .tag("https")
                }//Picker
                .pickerStyle(.segmented)
                HStack {
                    Text("FORWARD_HOST")
                    TextField("FORWARD_HOST", text: $host)
                        .multilineTextAlignment(.trailing)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
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
            
            Section {
                HStack {
                    Text("DOMAIN_NAMES")
                    TextField("DOMAIN_NAMES", text: $domain)
                        .multilineTextAlignment(.trailing)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .keyboardType(.URL)
                }//HStack
                HStack {
                    Spacer()
                    Button("ADD") {
                        if !self.domain.isEmpty {
                            self.domains.append(self.domain)
                            self.domain = ""
                        }
                    }
                    .disabled(self.domain.isEmpty)
                    Spacer()
                }
                
                List {
                    ForEach(self.domains, id: \.self) { dom in
                        Text(dom)
                    }
                    .onDelete { index in
                        self.domains.remove(atOffsets: index)
                    }
                }
            }//Section
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
        if self.host.isEmpty || self.port.isEmpty || self.domains.count == 0 {
            return
        }
        
        ProxiesRequest.create(
            schema: self.schema,
            host: self.host,
            port: Int(self.port)!,
            domains: self.domains) { success, record in
                if success {
                    self.appService.fetchProxies()
                    self.dismiss()
                }
            }
    }
}

#Preview {
    ProxiesCreateView()
}

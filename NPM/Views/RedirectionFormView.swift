//
//  RedirectionFormView.swift
//  NPM
//
//  Created by Yaser Almasri on 22/08/25.
//

import SwiftUI

struct RedirectionFormView: View {
    
    @EnvironmentObject var appService: AppService
    @Environment(\.dismiss) var dismiss
    
    @State private var domains: [String] = []
    @State private var scheme: String = "http"
    @State private var forwardDomain: String = ""
    @State private var httpCode: String = "300"
    @State private var domain: String = ""
    @State private var preservePath: Bool = false
    @State private var blockCommonExploits: Bool = false
    
    var validForm: Bool {
        if self.forwardDomain.isEmpty || self.domains.count == 0 {
            return false
        }
        
        return true
    }
    
    var redirection: Redirection?
    
    var body: some View {
        Form {
            forwardDomainSection
            
            domainsSection
        }
        .onAppear {
            if let red = self.redirection {
                self.domains = red.domain_names
                self.scheme = red.forward_scheme
                self.forwardDomain = red.forward_domain_name
                self.httpCode = String(red.forward_http_code)
                self.preservePath = red.preserve_path
                self.blockCommonExploits = red.block_exploits
            }
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
        if let red = self.redirection {
            RedirectionsRequest.update(
                id: red.id,
                scheme: self.scheme,
                forwardDomain: self.forwardDomain,
                httpCode: Int(self.httpCode)!,
                domains: self.domains,
                preservePath: self.preservePath,
                blockCommonExploit: self.blockCommonExploits) { success, redirection in
                    if success {
                        self.appService.fetchRedirections()
                        self.dismiss()
                    }
                }
        } else {
            RedirectionsRequest.create(
                scheme: self.scheme,
                forwardDomain: self.forwardDomain,
                httpCode: Int(self.httpCode)!,
                domains: self.domains,
                preservePath: self.preservePath,
                blockCommonExploit: self.blockCommonExploits) { success, redirection in
                    if success {
                        self.appService.fetchRedirections()
                        self.dismiss()
                    }
                }
        }
    }
}

extension RedirectionFormView {
    var forwardDomainSection: some View {
        Section {
            Picker("SCHEME", selection: $scheme) {
                Text("http")
                    .tag("http")
                Text("https")
                    .tag("https")
            }//Picker
            .pickerStyle(.segmented)
            
            VStack(alignment: .leading) {
                Text("FORWARD_DOMAIN")
                TextField("FORWARD_DOMAIN", text: $forwardDomain)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .keyboardType(.URL)
            }//HStack
            
            Picker("HTTP_CODE", selection: $httpCode) {
                Text("300 Multiple choices")
                    .tag("300")
                Text("301 Moved permanently")
                    .tag("301")
                Text("302 Found")
                    .tag("302")
                Text("303 See other")
                    .tag("303")
                Text("307 Temporary redirect")
                    .tag("307")
                Text("308 Permanent redirect")
                    .tag("308")
            }//Picker
            
            Toggle("PRESERVE_PATH", isOn: $preservePath)
            Toggle("BLOCK_COMMON_EXPLOITS", isOn: $blockCommonExploits)
        }//Section
    }//forwardDomainSection
    
    var domainsSection: some View {
        Section(header: Text("DOMAIN_NAMES")) {
            HStack {
                TextField("DOMAIN", text: $domain)
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
    }//domainsSection
}

#Preview {
    RedirectionFormView()
}

//
//  RedirectionsCreateView.swift
//  NPM
//
//  Created by Yaser Almasri on 19/08/25.
//

import SwiftUI

struct RedirectionsCreateView: View {
    
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
                    Text("FORWARD_DOMAIN")
                        .fontWeight(.bold)
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
            
            Section {
                HStack {
                    Text("DOMAIN_NAMES")
                        .fontWeight(.bold)
                    TextField("DOMAIN", text: $domain)
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

#Preview {
    RedirectionsCreateView()
}

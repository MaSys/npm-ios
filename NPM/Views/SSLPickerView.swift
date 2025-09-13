//
//  SSLPickerView.swift
//  NPM
//
//  Created by Yaser Almasri on 20/08/25.
//

import SwiftUI

struct SSLPickerView<T: SSLHost>: View {
    
    @EnvironmentObject var appService: AppService
    @Environment(\.dismiss) var dismiss
    
    var host: T
    
    @State private var selectedCert: Int = 0
    
    @State private var forceSSL: Bool = false
    @State private var httpSupport: Bool = false
    @State private var hsts: Bool = false
    @State private var hstsSubdomains: Bool = false
    
    var body: some View {
        Form {
            Section {
                Toggle("FORCE_SSL", isOn: $forceSSL)
                Toggle("HTTP_SUPPORT", isOn: $httpSupport)
                Toggle("HSTS_ENABLED", isOn: $hsts)
                Toggle("HSTS_SUBDOMAINS", isOn: $hstsSubdomains)
            }
            .disabled(self.selectedCert == 0)
            
            List {
                Button {
                    self.selectedCert = 0
                    self.forceSSL = false
                    self.httpSupport = false
                    self.hsts = false
                    self.hstsSubdomains = false
                } label: {
                    HStack {
                        Text("NONE")
                        Spacer()
                        if self.selectedCert == 0 {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                }//Button
                .tint(.primary)
                
                ForEach(self.appService.certs, id: \.id) { cert in
                    Button {
                        self.selectedCert = cert.id
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(cert.nice_name)
                                Text(LocalizedStringResource(stringLiteral: cert.provider))
                                    .foregroundStyle(.secondary)
                                    .font(.system(size: 14))
                            }
                            Spacer()
                            if cert.id == self.selectedCert {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.accentColor)
                            }
                        }
                    }//Button
                    .tint(.primary)
                }
            }//List
        }//vstack
        .onAppear {
            self.appService.fetchCerts()
            self.selectedCert = self.host.certificate_id
            self.forceSSL = self.host.ssl_forced
            self.httpSupport = self.host.http2_support
            self.hsts = self.host.hsts_enabled
            self.hstsSubdomains = self.host.hsts_subdomains
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    self.save()
                } label: {
                    Text("SAVE")
                }
            }
        }
    }
    
    private func save() {
        if self.host is Proxy {
            ProxiesRequest.updateSSL(
                id: self.host.id,
                cert_id: self.selectedCert,
                forceSSL: self.forceSSL,
                httpSupport: self.httpSupport,
                hsts: self.hsts,
                hstsSubdomains: self.hstsSubdomains
            ) { success in
                if success {
                    self.appService.fetchProxies()
                    self.dismiss()
                }
            }
        } else if self.host is Redirection {
            RedirectionsRequest.updateSSL(
                id: self.host.id,
                cert_id: self.selectedCert,
                forceSSL: self.forceSSL,
                httpSupport: self.httpSupport,
                hsts: self.hsts,
                hstsSubdomains: self.hstsSubdomains
            ) { success in
                if success {
                    self.appService.fetchRedirections()
                    self.dismiss()
                }
            }
        }
    }
}

#Preview {
    SSLPickerView(host: Proxy.fake())
}

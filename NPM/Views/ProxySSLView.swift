//
//  ProxySSLView.swift
//  NPM
//
//  Created by Yaser Almasri on 18/08/25.
//

import SwiftUI

struct ProxySSLView: View {
    
    @EnvironmentObject var appService: AppService
    @Environment(\.dismiss) var dismiss

    var proxy: Proxy
    
    @State private var selectedCert: Int = 0
    
    var body: some View {
        List {
            Button {
                self.selectedCert = 0
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
        .onAppear {
            self.selectedCert = self.proxy.certificate_id
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
        ProxiesRequest.updateSSL(id: self.proxy.id, cert_id: self.selectedCert) { success in
            if success {
                self.appService.fetchProxies()
                self.dismiss()
            }
        }
    }
}

#Preview {
    ProxySSLView(proxy: Proxy.fake())
        .environmentObject(AppService.shared)
}

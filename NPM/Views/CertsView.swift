//
//  CertsView.swift
//  NPM
//
//  Created by Yaser Almasri on 26/08/25.
//

import SwiftUI

struct CertsView: View {
    
    @EnvironmentObject var appService: AppService
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(self.appService.certs, id: \.id) { cert in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(cert.domain_names.first ?? "No domain")
                                        .font(.headline)
                                    if cert.domain_names.count > 1 {
                                        Text("+\(cert.domain_names.count - 1)")
                                            .font(.caption)
                                            .padding(4)
                                            .background(Color.blue.opacity(0.2))
                                            .cornerRadius(4)
                                    }
                                }
                                
                                HStack {
                                    Text(providerName(from: cert))
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            Spacer()
                            
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 11, height: 11)
                                .foregroundStyle(cert.inUse ? .green : .red)
                        }
                        HStack {
                            Text("CREATED: \(cert.created_on)")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(uiColor: UIColor.secondarySystemBackground))
                            .shadow(color: .gray.opacity(0.2), radius: 2, y: 1)
                    )
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                }
            }//lazy
        }//scrollview
        .onAppear {
            self.appService.fetchCerts()
            self.appService.setPlugins()
        }
    }
    
    private func providerName(from cert: Cert) -> String {
        let provider = NSLocalizedString(cert.provider, comment: "")
        if let plugin = self.appService.plugins[cert.meta.dns_provider ?? ""] {
            //return "\(provider) - \(plugin.name)"
            return provider + " - " + plugin.name
        }
        return provider
    }
}

#Preview {
    CertsView()
}

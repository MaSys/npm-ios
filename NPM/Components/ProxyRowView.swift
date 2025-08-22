//
//  ProxyRowView.swift
//  NPM
//
//  Created by Yaser Almasri on 14/08/25.
//

import SwiftUI

struct ProxyRowView: View {
    
    @EnvironmentObject var appService: AppService
    
    var proxy: Proxy
    
    var cert: Cert? {
        return self.appService.certs.first { c in
            c.id == self.proxy.certificate_id
        }
    }
        
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(proxy.domain_names.first ?? "No domain")
                            .font(.headline)
                        if proxy.domain_names.count > 1 {
                            Text("+\(proxy.domain_names.count - 1)")
                                .font(.caption)
                                .padding(4)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(4)
                        }
                    }
                    Text("\(proxy.forward_scheme)://\(proxy.forward_host):\(String(proxy.forward_port))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                StatusIconView(host: proxy)
            }
            HStack {
                Text("Created: \(proxy.created_on)")
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
}

#Preview {
    ProxyRowView(proxy: Proxy.fake())
}

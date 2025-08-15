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
        VStack {
            HStack {
                StatusIconView(online: proxy.enabled)
                
                VStack(alignment: .leading) {
                    ForEach(proxy.domain_names, id: \.self) { domain in
                        Text(domain)
                            .fontWeight(.bold)
                            .font(.system(size: 16))
                    }
                }
                
                Spacer()
            }
            
            HStack {
                Text("\(proxy.forward_scheme)://\(proxy.forward_host):\(String(proxy.forward_port))")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
                
                Spacer()
                
                if cert == nil {
                    Text("HTTP_ONLY")
                        .font(.system(size: 13))
                        .foregroundStyle(.gray)
                } else {
                    Text(LocalizedStringResource(stringLiteral: cert!.provider))
                        .font(.system(size: 13))
                        .foregroundStyle(.gray)
                }
            }
            .padding(.top, 2)
        }
    }
}

#Preview {
    ProxyRowView(proxy: Proxy.fake())
}

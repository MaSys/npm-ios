//
//  RedirectionRowView.swift
//  NPM
//
//  Created by Yaser Almasri on 19/08/25.
//

import SwiftUI

struct RedirectionRowView: View {
    
    @EnvironmentObject var appService: AppService
    
    var redirection: Redirection
    
    var cert: Cert? {
        return self.appService.certs.first { c in
            c.id == self.redirection.certificate_id
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                StatusIconView(host: self.redirection)
                
                VStack(alignment: .leading) {
                    ForEach(redirection.domain_names, id: \.self) { domain in
                        Text(domain)
                            .fontWeight(.bold)
                            .font(.system(size: 16))
                    }
                }
                
                Spacer()
            }
            
            HStack {
                Text(self.redirection.forward_domain_name)
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
    RedirectionRowView(redirection: Redirection.fake())
}

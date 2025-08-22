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
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(redirection.domain_names.first ?? "No domain")
                            .font(.headline)
                        if redirection.domain_names.count > 1 {
                            Text("+\(redirection.domain_names.count - 1)")
                                .font(.caption)
                                .padding(4)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(4)
                        }
                    }
                    Text(self.redirection.forward_domain_name)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                StatusIconView(host: redirection)
            }
            HStack {
                Text("Created: \(redirection.created_on)")
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
    RedirectionRowView(redirection: Redirection.fake())
}

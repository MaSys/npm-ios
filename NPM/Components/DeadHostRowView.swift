//
//  DeadHostRowView.swift
//  NPM
//
//  Created by Yaser Almasri on 15/09/25.
//

import SwiftUI

struct DeadHostRowView: View {
    
    var host: DeadHost
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(host.domain_names.first ?? "No domain")
                            .font(.headline)
                        if host.domain_names.count > 1 {
                            Text("+\(host.domain_names.count - 1)")
                                .font(.caption)
                                .padding(4)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(4)
                        }
                    }
                }
                Spacer()
                StatusIconView(host: host)
            }
            HStack {
                Text("CREATED: \(host.created_on)")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }
        }//vstack
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
    DeadHostRowView(host: DeadHost.fake())
}

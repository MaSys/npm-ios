//
//  StreamRowView.swift
//  NPM
//
//  Created by Yaser Almasri on 13/09/25.
//

import SwiftUI

struct StreamRowView: View {
    
    @EnvironmentObject var appService: AppService
    
    var stream: Stream
    
    var cert: Cert? {
        return self.appService.certs.first { c in
            c.id == self.stream.certificate_id
        }
    }
        
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("\(stream.incoming_port)")
                            .font(.headline)
                    }
                    
                    HStack {
                        Image(systemName: "arrow.turn.down.right")
                            .imageScale(.small)
                        Text("\(stream.forwarding_host):\(String(stream.forwarding_port))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                StatusIconView(host: stream)
            }
            HStack {
                Text("CREATED: \(stream.created_on)")
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
    StreamRowView(stream: Stream.fake())
}

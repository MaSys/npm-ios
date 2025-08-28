//
//  AccessListsView.swift
//  NPM
//
//  Created by Yaser Almasri on 26/08/25.
//

import SwiftUI

struct AccessListsView: View {
    
    @EnvironmentObject var appService: AppService
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(self.appService.accessLists, id: \.id) { accessList in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(accessList.name)
                            .font(.headline)
                        
                        HStack {
                            Text("\(accessList.items.count) Users")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(accessList.proxy_host_count) Proxy Host")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(accessList.clients.count) Rules")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Text("CREATED: \(accessList.created_on)")
                            .font(.caption)
                            .foregroundColor(.gray)
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
            }//lazy
        }//scrollview
        .onAppear {
            self.appService.fetchAccessLists()
            self.appService.setPlugins()
        }
    }
}

#Preview {
    AccessListsView()
}

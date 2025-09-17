//
//  DeadHostsView.swift
//  NPM
//
//  Created by Yaser Almasri on 15/09/25.
//

import SwiftUI

struct DeadHostsView: View {
    
    @EnvironmentObject var appService: AppService
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(self.appService.deadHosts, id: \.id) { host in
                    NavigationLink {
                        DeadHostFormView(host: host)
                            .environmentObject(AppService.shared)
                    } label: {
                        DeadHostRowView(host: host)
                            .environmentObject(AppService.shared)
                    }
                }//loop
            }
            .padding(.vertical, 8)
        }
        .navigationTitle("404_HOSTS")
        .onAppear {
            self.appService.fetchDeadHosts()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    DeadHostFormView()
                        .environmentObject(AppService.shared)
                } label: {
                    Image(systemName: "plus")
                }

            }
        }
    }
}

#Preview {
    DeadHostsView()
}

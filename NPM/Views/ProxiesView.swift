//
//  ProxiesView.swift
//  NPM
//
//  Created by Yaser Almasri on 13/08/25.
//

import SwiftUI

struct ProxiesView: View {
    
    @EnvironmentObject var appService: AppService

    var body: some View {
        NavigationStack {
            List {
                ForEach(self.appService.proxies, id: \.id) { proxy in
                    NavigationLink {
                        ProxyView(proxy: proxy)
                            .environmentObject(AppService.shared)
                    } label: {
                        ProxyRowView(proxy: proxy)
                            .environmentObject(AppService.shared)
                    }
                }
            }//List
            .navigationTitle("PROXY_HOSTS")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        ProxiesCreateView()
                            .environmentObject(AppService.shared)
                    } label: {
                        Image(systemName: "plus")
                    }

                }
            }
        }//NavStack
        .onAppear {
            self.appService.fetchProxies()
        }
    }
}

#Preview {
    ProxiesView()
}

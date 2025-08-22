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
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(self.appService.proxies, id: \.id) { proxy in
                        NavigationLink {
                            ProxyView(proxy: proxy)
                                .environmentObject(AppService.shared)
                        } label: {
                            ProxyRowView(proxy: proxy)
                                .environmentObject(AppService.shared)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("PROXY_HOSTS")
            .onAppear {
                self.appService.fetchProxies()
            }
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
    }
}

#Preview {
    AppService.shared.proxies = [Proxy.fake(), Proxy.fake()]
    return ProxiesView()
        .environmentObject(AppService.shared)
}

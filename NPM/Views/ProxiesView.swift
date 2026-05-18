//
//  ProxiesView.swift
//  NPM
//
//  Created by Yaser Almasri on 13/08/25.
//

import SwiftUI

struct ProxiesView: View {
    
    @EnvironmentObject var appService: AppService
    @State private var searchText = ""

    var filteredProxies: [Proxy] {
        guard !searchText.isEmpty else { return appService.proxies }
        let options: String.CompareOptions = [.caseInsensitive, .diacriticInsensitive]
        return appService.proxies.filter { proxy in
            proxy.domain_names.contains { $0.range(of: searchText, options: options) != nil }
            || proxy.forward_host.range(of: searchText, options: options) != nil
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(filteredProxies, id: \.id) { proxy in
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
            .refreshable(action: { self.appService.fetchProxies() })
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
        .searchable(text: $searchText, prompt: "Search")
    }
}

#Preview {
    AppService.shared.proxies = [Proxy.fake(), Proxy.fake()]
    return ProxiesView()
        .environmentObject(AppService.shared)
}

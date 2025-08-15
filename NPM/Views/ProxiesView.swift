//
//  ProxiesView.swift
//  NPM
//
//  Created by Yaser Almasri on 13/08/25.
//

import SwiftUI

struct ProxiesView: View {
    
    @EnvironmentObject var appService: AppService
    
    @State private var proxies: [Proxy] = []
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(proxies, id: \.id) { proxy in
                    NavigationLink {
                        EmptyView()
                    } label: {
                        ProxyRowView(proxy: proxy)
                    }
                }
            }
        }
        .onAppear {
            self.fetch()
        }
    }
    
    private func fetch() {
        ProxiesRequest.fetch { success, records in
            self.proxies = records
        }
    }
}

#Preview {
    ProxiesView()
}

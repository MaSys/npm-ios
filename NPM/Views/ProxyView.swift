//
//  ProxyView.swift
//  NPM
//
//  Created by Yaser Almasri on 17/08/25.
//

import SwiftUI

struct ProxyView: View {
    
    @EnvironmentObject var appService: AppService

    var proxy: Proxy
    
    @State private var cacheAssets: Bool = false
    @State private var blockCommonExploits: Bool = false
    @State private var websocketsSupport: Bool = false
    
    var accessList: String {
        if let accessList = self.appService.accessLists.first(where: { al in
            al.id == self.proxy.access_list_id
        }) {
            return accessList.name
        }
            
        return "PUBLICLY_ACCESSIBLE"
    }
    
    var body: some View {
        List {
            hostSection
            
            Section {
                Toggle("CACHE_ASSETS", isOn: $cacheAssets)
                Toggle("BLOCK_COMMON_EXPLOITS", isOn: $blockCommonExploits)
                Toggle("WEBSOCKETS_SUPPORT", isOn: $websocketsSupport)
            }
            
            Section {
                NavigationLink {
                    EmptyView()
                } label: {
                    HStack {
                        Text("ACCESS_LIST")
                        Spacer()
                        Text(LocalizedStringResource(stringLiteral: accessList))
                            .foregroundStyle(.secondary)
                    }//HStack
                }//HStack
                
                NavigationLink {
                    EmptyView()
                } label: {
                    Text("LOCATIONS")
                }//HStack
                
                NavigationLink {
                    EmptyView()
                } label: {
                    Text("SSL")
                }//HStack
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    NavigationLink(destination: {
                        EmptyView()
                    }, label: {
                        Image(systemName: "square.and.pencil")
                    })
                    
                    Button {
                        
                    } label: {
                        Image(systemName: self.proxy.enabled ? "power.circle.fill" : "power.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }

                }
            }
        }
    }
}

extension ProxyView {
    var hostSection: some View {
        Section {
            HStack {
                Text("HOST")
                    .fontWeight(.bold)
                Spacer()
                Text(self.proxy.host)
            }
            
            VStack(alignment: .leading) {
                Text("DOMAIN_NAMES")
                    .fontWeight(.bold)
                ForEach(self.proxy.domain_names, id: \.self) { domain in
                    HStack {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .frame(width: 7, height: 7)
                        Text(domain)
                    }
                    .padding(.leading, 2)
                }
            }
        }//Section
    }//hostSection
    
}

#Preview {
    ProxyView(proxy: Proxy.fake())
}

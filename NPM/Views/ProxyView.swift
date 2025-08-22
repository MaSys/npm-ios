//
//  ProxyView.swift
//  NPM
//
//  Created by Yaser Almasri on 17/08/25.
//

import SwiftUI

struct ProxyView: View {
    
    @EnvironmentObject var appService: AppService
    @Environment(\.dismiss) var dismiss

    var proxy: Proxy
    
    @State private var cacheAssets: Bool = false
    @State private var blockCommonExploits: Bool = false
    @State private var websocketsSupport: Bool = false
    @State private var isShowingDeleteConfirmation: Bool = false
    
    var accessList: String {
        if let accessList = self.appService.accessLists.first(where: { al in
            al.id == self.proxy.access_list_id
        }) {
            return accessList.name
        }
            
        return "PUBLICLY_ACCESSIBLE"
    }
    
    var cert: Cert? {
        return self.appService.certs.first { c in
            c.id == self.proxy.certificate_id
        }
    }
    
    var body: some View {
        List {
            hostSection
            
            Section {
                HStack {
                    Text("HOST")
                    Spacer()
                    Text(self.proxy.host)
                }
            }
            
            configSection
            
            authConfigSection
            
            deleteButton
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    NavigationLink(destination: {
                        ProxyEditView(proxy: self.proxy)
                            .environmentObject(self.appService)
                    }, label: {
                        Image(systemName: "square.and.pencil")
                    })
                    
                    Button {
                        ProxiesRequest.toggle(id: self.proxy.id, enabled: !self.proxy.enabled) { success in
                            if success {
                                self.appService.fetchProxies()
                            }
                        }
                    } label: {
                        Image(systemName: self.proxy.enabled ? "power.circle.fill" : "power.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }

                }
            }
        }
    }//body
    
    private func delete() {
        ProxiesRequest.delete(id: self.proxy.id) { success in
            if success {
                self.appService.fetchProxies()
                self.dismiss()
            }
        }
    }
}

extension ProxyView {
    var hostSection: some View {
        Section(header: Text("DOMAIN_NAMES")) {
            ForEach(self.proxy.domain_names, id: \.self) { domain in
                Link(domain, destination: fullDomain(from: domain))
            }
        }//Section
        .textCase(nil)
    }//hostSection
    
    var configSection: some View {
        Section {
            Toggle("CACHE_ASSETS", isOn: $cacheAssets)
            Toggle("BLOCK_COMMON_EXPLOITS", isOn: $blockCommonExploits)
            Toggle("WEBSOCKETS_SUPPORT", isOn: $websocketsSupport)
        }//section
    }
    
    var authConfigSection: some View {
        Section {
            NavigationLink {
                ProxyAccessListView(proxy: self.proxy)
                    .environmentObject(AppService.shared)
            } label: {
                HStack {
                    Text("ACCESS_LIST")
                    Spacer()
                    Text(LocalizedStringResource(stringLiteral: accessList))
                        .foregroundStyle(.secondary)
                }//HStack
            }//HStack
            
            NavigationLink {
                ProxyLocationsView(proxy: self.proxy)
                    .environmentObject(AppService.shared)
            } label: {
                Text("LOCATIONS")
            }//HStack
            
            NavigationLink {
                SSLPickerView(host: self.proxy)
                    .environmentObject(AppService.shared)
            } label: {
                HStack {
                    Text("SSL")
                    Spacer()
                    if cert != nil {
                        Text(cert!.nice_name)
                            .foregroundStyle(.secondary)
                    }
                }
            }//HStack
        }//section
    }
    
    var deleteButton: some View {
        Section {
            HStack {
                Spacer()
                Button("DELETE") {
                    self.isShowingDeleteConfirmation = true
                }
                .foregroundStyle(.red)
                .confirmationDialog("DELETE", isPresented: $isShowingDeleteConfirmation) {
                    Button("DELETE", role: .destructive) {
                        self.delete()
                    }
                    Button("CANCEL", role: .cancel) {}
                }
                Spacer()
            }//hstack
        }//section
    }
    
    private func fullDomain(from domain: String) -> URL {
        let scheme = self.proxy.certificate_id == 0 ? "http" : "https"
        return URL(string: "\(scheme)://\(domain)")!
    }
}

#Preview {
    ProxyView(proxy: Proxy.fake())
        .environmentObject(AppService.shared)
}

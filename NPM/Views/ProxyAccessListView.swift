//
//  ProxyAccessListView.swift
//  NPM
//
//  Created by Yaser Almasri on 18/08/25.
//

import SwiftUI

struct ProxyAccessListView: View {
    
    @EnvironmentObject var appService: AppService
    @Environment(\.dismiss) var dismiss

    var proxy: Proxy
    
    @State private var selectedAccessList: Int = 0
    
    var body: some View {
        List {
            Button {
                self.selectedAccessList = 0
            } label: {
                HStack {
                    Text("PUBLICLY_ACCESSIBLE")
                    Spacer()
                    if self.selectedAccessList == 0 {
                        Image(systemName: "checkmark")
                            .foregroundStyle(Color.accentColor)
                    }
                }
            }
            .tint(.primary)
            
            ForEach(self.appService.accessLists, id: \.id) { accessList in
                Button {
                    self.selectedAccessList = accessList.id
                } label: {
                    HStack {
                        Text(accessList.name)
                        Spacer()
                        if self.selectedAccessList == accessList.id {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.accentColor)
                        }
                    }//hstack
                }//button
                .tint(.primary)
            }//Loop
        }//List
        .onAppear {
            self.selectedAccessList = self.proxy.access_list_id
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    self.save()
                } label: {
                    Text("SAVE")
                }
            }
        }
    }
    
    private func save() {
        ProxiesRequest.updateAccessList(id: self.proxy.id, accessListId: self.selectedAccessList) { success in
            if success {
                self.appService.fetchProxies()
                self.dismiss()
            }
        }
    }
}

#Preview {
    ProxyAccessListView(proxy: Proxy.fake())
}

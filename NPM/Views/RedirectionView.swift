//
//  RedirectionView.swift
//  NPM
//
//  Created by Yaser Almasri on 20/08/25.
//

import SwiftUI

struct RedirectionView: View {
    
    @EnvironmentObject var appService: AppService

    var redirection: Redirection
    
    var cert: Cert? {
        return self.appService.certs.first { c in
            c.id == self.redirection.certificate_id
        }
    }
    
    var body: some View {
        List {
            domainNamesSection
            hostSection
            
            Section {
                NavigationLink {
                    SSLPickerView(host: self.redirection)
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
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    NavigationLink(destination: {
                        EmptyView()
                    }, label: {
                        Image(systemName: "square.and.pencil")
                    })
                    
// TODO: Enbale when it's implemented in the API
//                    Button {
//                        RedirectionsRequest.toggle(id: self.redirection.id, enabled: !self.redirection.enabled) { success in
//                            if success {
//                                self.appService.fetchRedirections()
//                            }
//                        }
//                    } label: {
//                        Image(systemName: self.redirection.enabled ? "power.circle.fill" : "power.circle")
//                            .resizable()
//                            .frame(width: 25, height: 25)
//                    }

                }
            }
        }
    }
}

extension RedirectionView {
    var domainNamesSection: some View {
        Section(header: Text("DOMAIN_NAMES")) {
            ForEach(self.redirection.domain_names, id: \.self) { domain in
                Text(domain)
            }
        }//Section
        .textCase(nil)
    }//domainNamesSection
    
    var hostSection: some View {
        Section {
            HStack {
                Text("HOST")
                Spacer()
                Text("\(self.redirection.forward_scheme)://\(self.redirection.forward_domain_name)")
            }
            HStack {
                Text("HTTP_CODE")
                Spacer()
                Text(String(redirection.forward_http_code))
            }
        }//section
    }//hostSection
}

#Preview {
    RedirectionView(redirection: Redirection.fake())
}

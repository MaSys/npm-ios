//
//  ProxyLocationsView.swift
//  NPM
//
//  Created by Yaser Almasri on 18/08/25.
//

import SwiftUI

struct ProxyLocationsView: View {
    
    @EnvironmentObject var appService: AppService
    @Environment(\.dismiss) var dismiss

    var proxy: Proxy
    
    @State private var path: String = ""
    @State private var scheme: String = "http"
    @State private var host: String = ""
    @State private var port: String = ""
    
    @State private var locations: [Location] = []
    
    var validForm: Bool {
        if self.path.isEmpty || self.host.isEmpty || self.port.isEmpty { return false }
        
        return true
    }
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("LOCATION")
                        .fontWeight(.bold)
                    TextField("/path", text: $path)
                        .multilineTextAlignment(.trailing)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                }
                
                Picker("SCHEME", selection: $scheme) {
                    Text("http").tag("http")
                    Text("https").tag("https")
                }
                .pickerStyle(.segmented)
                
                VStack(alignment: .leading) {
                    Text("FORWARD_HOST")
                        .fontWeight(.bold)
                    TextField("203.0.113.25/path/", text: $host)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                }
                
                HStack {
                    Text("FORWARD_PORT")
                        .fontWeight(.bold)
                    TextField("80", text: $port)
                        .multilineTextAlignment(.trailing)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                        .keyboardType(.numberPad)
                }
                
                HStack {
                    Spacer()
                    Button("ADD") {
                        self.locations.append(Location(path: self.path, forward_scheme: self.scheme, forward_host: self.host, forward_port: Int(self.port)!, advanced_config: ""))
                    }
                    .disabled(!validForm)
                    Spacer()
                }
            }//section
            
            ForEach(self.locations, id: \.id) { location in
                VStack {
                    HStack {
                        Text("LOCATION")
                            .fontWeight(.bold)
                        Spacer()
                        Text(location.path)
                    }
                    HStack {
                        Text("SCHEME")
                            .fontWeight(.bold)
                        Spacer()
                        Text(location.forward_scheme)
                    }
                    HStack {
                        Text("FORWARD_HOST")
                            .fontWeight(.bold)
                        Spacer()
                        Text(location.forward_host)
                    }
                    HStack {
                        Text("FORWARD_PORT")
                            .fontWeight(.bold)
                        Spacer()
                        Text(String(location.forward_port))
                    }
                }//vstack
            }//loop
            .onDelete { index in
                self.locations.remove(atOffsets: index)
            }
        }//form
        .onAppear {
            if let locs = self.proxy.locations {
                self.locations = locs
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("SAVE") {
                    self.save()
                }
            }
        }
    }
    
    private func forwardedHost(location: Location) -> String {
        return "\(location.forward_scheme)://\(location.forward_host)/\(location.forward_path ?? "")"
    }
    
    private func save() {
        ProxiesRequest.updateLocations(id: self.proxy.id, locations: self.locations) { success in
            if success {
                self.appService.fetchProxies()
                self.dismiss()
            }
        }
    }
}

#Preview {
    ProxyLocationsView(proxy: Proxy.fake())
}

//
//  AccessListFormView.swift
//  NPM
//
//  Created by Yaser Almasri on 28/08/25.
//

import SwiftUI

struct AccessListFormView: View {
    
    @EnvironmentObject var appService: AppService
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var satisfyAny: Bool = false
    @State private var passAuth: Bool = false
    
    @State private var credentials: [Credential] = []
    @State private var ipAddresses: [IpAddress] = []
    
    @State private var isLoading: Bool = false
    @State private var isShowingDeleteConfirmation: Bool = false
    
    var accessList: AccessList?
    
    var validForm: Bool {
        if self.name.isEmpty {
            return false
        }
        if self.credentials.isEmpty && self.ipAddresses.isEmpty {
            return false
        }
        return true
    }
    
    var body: some View {
        Form {
            detailsSection
            
            authorizationSection
            
            accessSection
            
            if self.accessList != nil {
                deleteButton
            }
        }
        .onAppear {
            if let access = self.accessList {
                self.name = access.name
                self.satisfyAny = access.satisfy_any
                self.passAuth = access.pass_auth
                self.credentials = access.items.map({ item in
                    return Credential(username: item.username, password: item.password, hint: item.hint)
                })
                self.ipAddresses = access.clients.map({ client in
                    return IpAddress(directive: client.directive, address: client.address)
                })
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("SAVE") {
                    self.save()
                }
                .disabled(self.isLoading)
            }
        }
    }
    
    private func save() {
        if !self.validForm { return }
        self.isLoading = true
        
        if self.accessList == nil {
            AccessListsRequest.create(
                name: self.name,
                satisfyAny: self.satisfyAny,
                passAuth: self.passAuth,
                items: self.credentials.map({ cred in
                    return ["username": cred.username, "password": cred.password]
                }),
                clients: self.ipAddresses.map({ ip in
                    return ["directive": ip.directive, "address": ip.address]
                })
            ) { success, record in
                self.isLoading = false
                if success {
                    self.appService.fetchAccessLists()
                    self.dismiss()
                }
            }
        } else {
            AccessListsRequest.update(
                id: self.accessList!.id,
                name: self.name,
                satisfyAny: self.satisfyAny,
                passAuth: self.passAuth,
                items: self.credentials.map({ cred in
                    return ["username": cred.username, "password": cred.password]
                }),
                clients: self.ipAddresses.map({ ip in
                    return ["directive": ip.directive, "address": ip.address]
                })
            ) { success, record in
                self.isLoading = false
                if success {
                    self.appService.fetchAccessLists()
                    self.dismiss()
                }
            }
        }
    }//save
    
    private func delete() {
        if let al = self.accessList {
            AccessListsRequest.delete(id: al.id) { success in
                if success {
                    self.appService.fetchAccessLists()
                    self.dismiss()
                }
            }
        }
    }
}

extension AccessListFormView {
    var detailsSection: some View {
        Section {
            HStack {
                Text("NAME")
                Spacer()
                TextField("NAME", text: $name)
                    .multilineTextAlignment(.trailing)
                    .autocorrectionDisabled()
                    .autocapitalization(.words)
            }//hstack
            
            Toggle("SATISFY_ANY", isOn: $satisfyAny)
            Toggle("PASS_AUTH", isOn: $passAuth)
        }//section
    }//detailsSection
    
    var authorizationSection: some View {
        Section(header: HStack{
            Text("AUTHORIZATION")
            Spacer()
            Button {
                self.credentials.append(Credential(username: "", password: ""))
            } label: {
                HStack {
                    Text("ADD")
                        .font(.footnote)
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.small)
                }
            }
        }) {
            ForEach($credentials) { $credential in
                HStack {
                    TextField("USERNAME", text: $credential.username)
                    SecureField(LocalizedStringResource(stringLiteral: credential.hint), text: $credential.password)
                        .multilineTextAlignment(.trailing)
                }
            }//loop
            .onDelete { indexSet in
                self.credentials.remove(atOffsets: indexSet)
            }
        }//section
    }//authorizationSection
    
    var accessSection: some View {
        Section(header: HStack{
            Text("ACCESS")
            Spacer()
            Button {
                self.ipAddresses.append(IpAddress(directive: "allow", address: ""))
            } label: {
                HStack {
                    Text("ADD")
                        .font(.footnote)
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.small)
                }
            }
        }) {
            ForEach($ipAddresses) { $ipAddress in
                HStack {
                    Picker("", selection: $ipAddress.directive) {
                        Text("allow")
                            .tag("allow")
                        Text("deny")
                            .tag("deny")
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    TextField("IP / Subnet", text: $ipAddress.address)
                }
            }//loop
            .onDelete { indexSet in
                self.ipAddresses.remove(atOffsets: indexSet)
            }
        }//section
    }//accessSection
    
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
    }//deleteButton
}

#Preview {
    AccessListFormView()
        .environmentObject(AppService.shared)
}

struct Credential: Identifiable {
    let id = UUID()
    var username: String
    var password: String
    var hint: String = "PASSWORD"
}
struct IpAddress: Identifiable {
    let id = UUID()
    var directive: String
    var address: String
}

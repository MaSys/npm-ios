//
//  DeadHostFormView.swift
//  NPM
//
//  Created by Yaser Almasri on 15/09/25.
//

import SwiftUI

struct DeadHostFormView: View {
    
    @EnvironmentObject var appService: AppService
    @Environment(\.dismiss) var dismiss
    
    var host: DeadHost?
    
    @State private var domain: String = ""
    @State private var domains: [String] = []
    
    @State private var certificateId: Int = 0
    
    @State private var forceSSL: Bool = false
    @State private var httpSupport: Bool = false
    @State private var hsts: Bool = false
    @State private var hstsSubdomains: Bool = false
    
    @State private var isLoading: Bool = false
    @State private var isShowingDeleteConfirmation: Bool = false
    
    var validForm: Bool {
        if self.domains.isEmpty { return false }
        
        return true
    }
    
    init(host: DeadHost? = nil) {
        self.host = host
        if let deadHost = host {
            self._domains = State(initialValue: deadHost.domain_names)
            self._certificateId = State(initialValue: deadHost.certificate_id)
            self._forceSSL = State(initialValue: deadHost.ssl_forced)
            self._httpSupport = State(initialValue: deadHost.http2_support)
            self._hsts = State(initialValue: deadHost.hsts_enabled)
            self._hstsSubdomains = State(initialValue: deadHost.hsts_subdomains)
        }
    }
    
    var body: some View {
        Form {
            domainsSection
            
            sslSection
            
            if self.host != nil {
                deleteButton
            }
        }//form
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("SAVE") {
                    self.save()
                }
                .disabled(self.isLoading || !self.validForm)
            }
        }
    }
    
    private func save() {
        if !self.validForm { return }
        
        self.isLoading = true
        if self.host == nil {
            DeadHostsRequest.create(
                domains: self.domains,
                certificateId: self.certificateId,
                forceSSL: self.forceSSL,
                httpSupport: self.httpSupport,
                hsts: self.hsts,
                hstsSubdomains: self.hstsSubdomains
            ) { success, record in
                self.isLoading = false
                if success {
                    self.appService.fetchDeadHosts()
                    self.dismiss()
                }
            }
        } else {
            DeadHostsRequest.update(
                id: self.host!.id,
                domains: self.domains,
                certificateId: self.certificateId,
                forceSSL: self.forceSSL,
                httpSupport: self.httpSupport,
                hsts: self.hsts,
                hstsSubdomains: self.hstsSubdomains
            ) { success, record in
                self.isLoading = false
                if success {
                    self.appService.fetchDeadHosts()
                    self.dismiss()
                }
            }
        }
    }
    
    private func delete() {
        self.isLoading = true
        DeadHostsRequest.delete(
            id: self.host!.id,
        ) { success in
            self.isLoading = false
            if success {
                self.appService.fetchDeadHosts()
                self.dismiss()
            }
        }
    }
}

extension DeadHostFormView {
    var domainsSection: some View {
        Section(header: Text("DOMAIN_NAMES")) {
            HStack {
                TextField("my.domain.local", text: $domain)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .keyboardType(.URL)
                Divider()
                Button("ADD") {
                    if !self.domain.isEmpty {
                        self.domains.append(self.domain)
                        self.domain = ""
                    }
                }
                .disabled(self.domain.isEmpty)
            }//HStack
            
            List {
                ForEach(self.domains, id: \.self) { dom in
                    Text(dom)
                }
                .onDelete { index in
                    self.domains.remove(atOffsets: index)
                }
            }
        }//Section
        .textCase(nil)
    }//domainsSection
    
    var sslSection: some View {
        Section {
            Toggle("FORCE_SSL", isOn: $forceSSL)
                .disabled(self.certificateId == 0)
            Toggle("HTTP_SUPPORT", isOn: $httpSupport)
                .disabled(self.certificateId == 0)
            Toggle("HSTS_ENABLED", isOn: $hsts)
                .disabled(self.certificateId == 0)
            Toggle("HSTS_SUBDOMAINS", isOn: $hstsSubdomains)
                .disabled(self.certificateId == 0)
            
            Picker("SSL", selection: $certificateId) {
                Text("NONE").tag(0)
                ForEach(self.appService.certs, id: \.id) { cert in
                    Text(cert.nice_name).tag(cert.id)
                }
            }
            .pickerStyle(.navigationLink)
            .onChange(of: self.certificateId) { oldValue, newValue in
                if self.certificateId == 0 {
                    self.forceSSL = false
                    self.httpSupport = false
                    self.hsts = false
                    self.hstsSubdomains = false
                }
            }
        }
    }//sslSection
    
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
    DeadHostFormView()
}

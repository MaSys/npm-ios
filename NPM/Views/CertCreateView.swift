//
//  CertCreateView.swift
//  NPM
//
//  Created by Yaser Almasri on 22/09/25.
//

import SwiftUI

struct CertCreateView: View {

    @EnvironmentObject var appService: AppService
    @Environment(\.dismiss) var dismiss

    @State private var domain: String = ""
    @State private var domains: [String] = []
    @State private var dnsChallenge: Bool = false

    @State private var dnsProvider: String = ""
    @State private var credentials: String = ""
    @State private var seconds: String = ""

    @State private var isLoading: Bool = false

    var validForm: Bool {
        guard !domains.isEmpty else { return false }
        if dnsChallenge {
            return !dnsProvider.isEmpty && !credentials.isEmpty
        }
        return true
    }

    var body: some View {
        Form {
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

            Section {
                Toggle("USE_DNS_CHALLENGE", isOn: $dnsChallenge)
            }

            if self.dnsChallenge {
                Section {
                    Picker("DNS_PROVIDER", selection: $dnsProvider) {
                        Text("").tag("")
                        ForEach(Array(self.appService.plugins).sorted(by: { $0.value.name < $1.value.name }), id: \.key) { key, provider in
                            Text(provider.name).tag(key)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .onChange(of: dnsProvider) { _, newKey in
                        if let plugin = self.appService.plugins[newKey] {
                            self.credentials = plugin.credentials
                        }
                    }
                }//section

                if !self.dnsProvider.isEmpty {
                    Section(header: Text("CREDENTIALS")) {
                        TextEditor(text: $credentials)
                            .font(.system(.body, design: .monospaced))
                            .frame(minHeight: 120)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                    }
                    .textCase(nil)

                    Section(header: Text("PROPAGATION_SECONDS")) {
                        TextField("120", text: $seconds)
                            .keyboardType(.numberPad)
                    }
                    .textCase(nil)
                }
            }//if dnsChallenge
        }//form
        .navigationTitle("NEW_CERT")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("SAVE") {
                    self.save()
                }
                .disabled(self.isLoading || !self.validForm)
            }
        }
        .onAppear {
            self.appService.setPlugins()
        }
    }

    private func save() {
        guard self.validForm else { return }
        self.isLoading = true
        let propagationSeconds = Int(self.seconds)
        CertsRequest.create(
            domains: self.domains,
            dnsChallenge: self.dnsChallenge,
            dnsProvider: self.dnsProvider,
            dnsCredentials: self.credentials,
            propagationSeconds: propagationSeconds
        ) { success, _ in
            self.isLoading = false
            if success {
                self.appService.fetchCerts()
                self.dismiss()
            }
        }
    }
}

#Preview {
    CertCreateView()
}

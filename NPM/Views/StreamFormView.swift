//
//  StreamFormView.swift
//  NPM
//
//  Created by Yaser Almasri on 13/09/25.
//

import SwiftUI

struct StreamFormView: View {
    
    @EnvironmentObject var appService: AppService
    @Environment(\.dismiss) var dismiss
    
    var stream: Stream?
    
    @State private var incomingPort: String = ""
    @State private var forwardHost: String = ""
    @State private var forwardPort: String = ""
    @State private var tcpForwarding: Bool = false
    @State private var udpForwarding: Bool = false
    @State private var certificateId: Int = 0
    
    @State private var isLoading: Bool = false
    @State private var isShowingDeleteConfirmation: Bool = false
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("INCOMING_PORT")
                    TextField("INCOMING_PORT", text: $incomingPort)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                }
            }//section
            
            Section {
                VStack(alignment: .leading) {
                    Text("FORWARD_HOST")
                    TextField("FORWARD_HOST", text: $forwardHost)
                        .keyboardType(.URL)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                }//vstack
                
                HStack {
                    Text("FORWARD_PORT")
                    TextField("FORWARD_PORT", text: $forwardPort)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                }//hstack
            }//section
            
            Section {
                Toggle("TCP_FORWARDING", isOn: $tcpForwarding)
                Toggle("UDP_FORWARDING", isOn: $udpForwarding)
            }
            
            certificatePicker
            
            if self.stream != nil {
                deleteButton
            }
        }//form
        .onAppear {
            if let strm = self.stream {
                self.incomingPort = String(strm.incoming_port)
                self.forwardHost = strm.forwarding_host
                self.forwardPort = String(strm.forwarding_port)
                self.tcpForwarding = strm.tcp_forwarding
                self.udpForwarding = strm.udp_forwarding
                self.certificateId = strm.certificate_id
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
        self.isLoading = true
        if self.stream == nil {
            StreamsRequest.create(
                incomingPort: Int(self.incomingPort)!,
                forwardHost: self.forwardHost,
                forwardPort: Int(self.forwardPort)!,
                tcpForwarding: self.tcpForwarding,
                udpForwarding: self.udpForwarding,
                certificateId: self.certificateId
            ) { success, record in
                self.isLoading = false
                if success {
                    self.appService.fetchStreams()
                    self.dismiss()
                }
            }
        } else {
            StreamsRequest.update(
                id: self.stream!.id,
                incomingPort: Int(self.incomingPort)!,
                forwardHost: self.forwardHost,
                forwardPort: Int(self.forwardPort)!,
                tcpForwarding: self.tcpForwarding,
                udpForwarding: self.udpForwarding,
                certificateId: self.certificateId
            ) { success, record in
                self.isLoading = false
                if success {
                    self.appService.fetchStreams()
                    self.dismiss()
                }
            }
        }
    }
    
    private func delete() {
        if let strm = self.stream {
            self.isLoading = true
            StreamsRequest.delete(id: strm.id) { success in
                self.isLoading = false
                if success {
                    self.appService.fetchStreams()
                    self.dismiss()
                }
            }
        }
    }
}

extension StreamFormView {
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
    
    var certificatePicker: some View {
        Picker("SSL", selection: $certificateId) {
            Text("NONE")
                .tag(0)
            ForEach(self.appService.certs, id: \.id) { cert in
                Text(cert.nice_name)
                    .tag(cert.id)
            }
        }//picker
        .pickerStyle(.navigationLink)
    }//certificatePicker
}

#Preview {
    StreamFormView()
}

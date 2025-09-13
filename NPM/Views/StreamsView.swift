//
//  StreamsView.swift
//  NPM
//
//  Created by Yaser Almasri on 13/09/25.
//

import SwiftUI

struct StreamsView: View {
    
    @EnvironmentObject var appService: AppService
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(self.appService.streams, id: \.id) { stream in
                    NavigationLink {
                        StreamFormView(stream: stream)
                            .environmentObject(self.appService)
                    } label: {
                        StreamRowView(stream: stream)
                    }
                }
            }
            .padding(.vertical, 8)
        }//scrollview
        .background(Color(.systemGroupedBackground))
        .navigationTitle("STREAMS")
        .refreshable(action: { self.appService.fetchStreams() })
        .onAppear {
            self.appService.fetchStreams()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    StreamFormView()
                        .environmentObject(self.appService)
                } label: {
                    Image(systemName: "plus")
                }
                
            }
        }
    }
}

#Preview {
    StreamsView()
        .environmentObject(AppService.shared)
}

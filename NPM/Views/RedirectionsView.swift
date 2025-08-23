//
//  RedirectionsView.swift
//  NPM
//
//  Created by Yaser Almasri on 13/08/25.
//

import SwiftUI

struct RedirectionsView: View {
    
    @EnvironmentObject var appService: AppService

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(self.appService.redirections, id: \.id) { redirection in
                        NavigationLink {
                            RedirectionView(redirection: redirection)
                                .environmentObject(AppService.shared)
                        } label: {
                            RedirectionRowView(redirection: redirection)
                                .environmentObject(AppService.shared)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("REDIRECTIONS")
            .onAppear {
                self.appService.fetchRedirections()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        RedirectionFormView()
                            .environmentObject(self.appService)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    RedirectionsView()
        .environmentObject(AppService.shared)
}

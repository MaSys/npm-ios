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
            List {
                ForEach(self.appService.redirections, id: \.id) { redirection in
                    NavigationLink {
                        EmptyView()
                    } label: {
                        RedirectionRowView(redirection: redirection)
                            .environmentObject(AppService.shared)
                    }
                }
            }
            .navigationTitle("REDIRECTIONS")
            .onAppear {
                self.appService.fetchRedirections()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        RedirectionsCreateView()
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

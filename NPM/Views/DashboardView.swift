//
//  DashboardView.swift
//  NPM
//
//  Created by Yaser Almasri on 13/08/25.
//

import SwiftUI

struct DashboardView: View {
    
    @State private var report: ReportHost = ReportHost(proxy: 0, redirection: 0, stream: 0, dead: 0)
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                let squareSize = (geometry.size.width - 40) / 2 // 20 padding + 10 spacing
                VStack {
                    HStack {
                        DashboardCardView(
                            text: "PROXY_HOSTS",
                            icon: "bolt.horizontal",
                            value: "\(report.proxy)",
                            color: .green,
                            width: squareSize
                        )
                        DashboardCardView(
                            text: "REDIRECTION_HOSTS",
                            icon: "bolt.horizontal",
                            value: "\(report.redirection)",
                            color: .yellow,
                            width: squareSize
                        )
                    }
                    
                    HStack {
                        DashboardCardView(
                            text: "STREAMS",
                            icon: "bolt.horizontal",
                            value: "\(report.stream)",
                            color: .blue,
                            width: squareSize
                        )
                        DashboardCardView(
                            text: "404_HOSTS",
                            icon: "bolt.horizontal",
                            value: "\(report.dead)",
                            color: .red,
                            width: squareSize
                        )
                    }
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("DASHBOARD")
        }
        .onAppear {
            self.fetch()
        }
    }
    
    private func fetch() {
        ReportsRequest.fetch { success, record in
            if success, let record = record {
                self.report = record
            }
        }
    }
}

#Preview {
    DashboardView()
}

//
//  DashboardCardView.swift
//  NPM
//
//  Created by Yaser Almasri on 13/08/25.
//

import SwiftUI

struct DashboardCardView: View {
    
    var text: String
    var icon: String
    var value: String
    var color: Color
    var width: Double
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(color)
            .frame(width: width, height: 60)
            .overlay {
                VStack {
                    HStack {
                        Image(systemName: icon)
                            .imageScale(.small)
                        Text(LocalizedStringResource(stringLiteral: text))
                            .font(.system(size: 12))
                        Spacer()
                    }
                    .padding(.bottom, 2)
                
                    HStack {
                        Text(value)
                            .fontWeight(.bold)
                        Spacer()
                    }
                }
                .foregroundStyle(.white)
                .padding(.horizontal)
            }
    }
}

#Preview {
    DashboardCardView(
        text: "PROXY_HOSTS",
        icon: "bolt.horizontal",
        value: "25",
        color: .green,
        width: 150
    )
}

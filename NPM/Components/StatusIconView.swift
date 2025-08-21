//
//  StatusIconView.swift
//  NPM
//
//  Created by Yaser Almasri on 15/08/25.
//

import SwiftUI

struct StatusIconView<T: Host>: View {
    
    var host: T
    
    var color: Color {
        if self.host.meta.nginx_online == false {
            return .red
        } else if self.host.enabled == false {
            return .yellow
        } else {
            return .green
        }
    }
    
    var body: some View {
        Image(systemName: "circle.fill")
            .resizable()
            .frame(width: 11, height: 11)
            .foregroundStyle(color)
    }
}

#Preview {
    StatusIconView(host: Proxy.fake())
}

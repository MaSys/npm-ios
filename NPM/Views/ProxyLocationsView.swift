//
//  ProxyLocationsView.swift
//  NPM
//
//  Created by Yaser Almasri on 18/08/25.
//

import SwiftUI

struct ProxyLocationsView: View {
    
    @EnvironmentObject var appService: AppService

    var proxy: Proxy
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ProxyLocationsView(proxy: Proxy.fake())
}

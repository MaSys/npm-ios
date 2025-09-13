//
//  StreamFormView.swift
//  NPM
//
//  Created by Yaser Almasri on 13/09/25.
//

import SwiftUI

struct StreamFormView: View {
    
    @EnvironmentObject var appService: AppService
    
    var stream: Stream?
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    StreamFormView()
}

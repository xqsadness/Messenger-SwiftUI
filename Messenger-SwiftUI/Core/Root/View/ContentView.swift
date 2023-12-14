//
//  ContentView.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 12/12/2023.
//

import SwiftUI

struct ContentView: View {
    @Bindable var viewModel = ContentViewModel()
    
    var body: some View {
        Group{
            if viewModel.userSession != nil{
                InboxView()
            }else{
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}

//
//  LoadingView.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 14/12/2023.
//

import SwiftUI

struct LoadingView: View {
    @Binding var show: Bool
    var body: some View {
        ZStack{
            if show{
                Group{
                    Rectangle()
                        .fill(.text.opacity(0.4))
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .padding(15)
                        .background(.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
        }
        .animation(.easeIn(duration: 0.25), value: show)
        .ignoresSafeArea(.all)
    }
}

#Preview {
    LoadingView(show: .constant(true))
}

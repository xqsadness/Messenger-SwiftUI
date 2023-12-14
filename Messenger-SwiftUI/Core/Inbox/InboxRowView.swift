//
//  InboxRowView.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import SwiftUI

struct InboxRowView: View {
    @State private var isAppeared = false

    var body: some View {
        HStack(alignment: .top, spacing: 12){
            CircularProfileImageView(user: User.MOCK_USER, size: .medium)
            
            VStack(alignment: .leading, spacing: 4){
                Text("Heath Leder")
                    .foregroundStyle(.text)
                    .font(.bold(size: 14))
                
                Text("Some text messs that spans more than one line")
                    .foregroundStyle(.gray)
                    .font(.regular(size: 14))
                    .lineLimit(2)
                    .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
            }
            
            HStack{
                Text("Yesterday")
                    .font(.regular(size: 14))
                    .foregroundStyle(.gray)
                
                Image(systemName: "chevron.right")
                    .imageScale(.small)
                    .foregroundStyle(.gray)
            }
        }
        .frame(height: 72)
        .opacity(isAppeared ? 1 : 0)
        .offset(x: isAppeared ? 0 : -50)
        .onAppear {
            withAnimation {
                isAppeared = true
            }
        }
    }
}

#Preview {
    InboxRowView()
}

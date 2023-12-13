//
//  InboxRowView.swift
//  Messenger-SwiftUI
//
//  Created by darktech4 on 13/12/2023.
//

import SwiftUI

struct InboxRowView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12){
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 64, height: 64)
                .foregroundStyle(Color(.systemGray4))
            
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
    }
}

#Preview {
    InboxRowView()
}

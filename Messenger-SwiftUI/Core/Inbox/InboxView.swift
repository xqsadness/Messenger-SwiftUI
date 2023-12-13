//
//  InboxView.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 13/12/2023.
//

import SwiftUI

struct InboxView: View {
    @EnvironmentObject var coordinator: Coordinator
        
    var body: some View {
        VStack{
            header
            
            ScrollView(showsIndicators: false){
                ActiveNowView()
                
                List{
                    ForEach(0...10, id: \.self){ message in
                        InboxRowView()
                    }
                }
                .listStyle(PlainListStyle())
                .frame(height: UIScreen.main.bounds.height - 120)
            }
        }
    }
}

#Preview {
    InboxView()
}

extension InboxView{
    private var header: some View{
        HStack{
            Image(systemName: "person.circle.fill")
            
            Text("Charts")
                .font(.semibold(size: 24))
                .foregroundStyle(.text)
            
            Spacer()
            
            Button{
                coordinator.presentFullScreen(.mewMessageView)
            }label: {
                Image(systemName: "square.and.pencil.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(.text, Color(.systemGray5))
            }
        }
        .hAlign(.leading)
        .padding(.horizontal)
    }
}

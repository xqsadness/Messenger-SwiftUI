//
//  NotificationView.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 14/12/2023.
//

import SwiftUI

struct NotificationView: View {
    @StateObject var appController = AppController.instance
    @StateObject var localNotification = LocalNotification.shared
    
    var body: some View {
        HStack{
            Image(systemName: localNotification.toastStatus.icon())
                .imageScale(.medium)
                .foregroundColor(localNotification.toastStatus.color())
                .padding(.trailing,5)
            
            Text(appController.MESSAGE_ON_SCREEN)
                .font(.medium(size: 14))
                .foregroundColor(.toastForeground)
                .lineLimit(6)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Image(systemName: "x.circle")
                .imageScale(.medium)
                .foregroundColor(.text)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 1)){
                        appController.SHOW_MESSAGE_ON_SCREEN  = false
                    }
                }
        }
        .padding()
        .hAlign(.leading)
        .background(Color.toastBackground)
        .cornerRadius(10)
        .padding(.horizontal, 20)
        .padding(.bottom, 70)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(localNotification.toastStatus.color(), lineWidth: 3)
                .frame(maxWidth: .infinity)
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .padding(.bottom, 70)
                .shadow(color: localNotification.toastStatus.color(), radius: 2, x: 0, y: 1)
        )
    }
}

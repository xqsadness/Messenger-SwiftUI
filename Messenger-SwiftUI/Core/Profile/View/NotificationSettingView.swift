//
//  NotificationSettingView.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 27/12/2023.
//

import SwiftUI

struct NotificationSettingView: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject private var appcontroller = AppController.instance
    
    var body: some View {
        VStack{
            HStack {
                Image(systemName: "chevron.left")
                    .imageScale(.medium)
                    .foregroundStyle(.text)
                
                Text("Notifications")
                    .font(.semibold(size: 16))
                    .foregroundStyle(.text)
            }
            .hAlign(.leading)
            .contentShape(Rectangle())
            .onTapGesture {
                coordinator.pop()
            }
            .padding(.bottom, 20)
            
            Toggle("Notifications", isOn: $appcontroller.allowNotification)
                .tint(.blue)
            
            
            Text("If you turn off notifications you will not receive message notifications from friends")
                .font(.regular(size: 13))
                .padding(.vertical,5)
                .hAlign(.leading)
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    //    @MainActor
    //    func requestNotificationAuthorization() {
    //        let center = UNUserNotificationCenter.current()
    //
    //        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    //
    //        center.requestAuthorization(options: options) { (granted, error) in
    //            if granted {
    //                DispatchQueue.main.async {
    //                  appcontroller.allowNotification = true
    //                }
    //            } else {
    //                DispatchQueue.main.async {
    //                  appcontroller.allowNotification = false
    //                }
    //            }
    //        }
    //    }
}

#Preview {
    NotificationSettingView()
}

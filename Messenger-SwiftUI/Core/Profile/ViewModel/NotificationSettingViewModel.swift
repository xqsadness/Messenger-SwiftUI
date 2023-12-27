//
//  NotificationSettingViewModel.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 27/12/2023.
//

import SwiftUI
import Combine

class NotificationSettingViewModel: ObservableObject{
    
    //Props
    @Published var notificationsEnabled = true{
        didSet{
            if notificationsEnabled{
                self.enableNotifications()
            }else{
                self.disableNotifications()
            }
        }
    }
    
    @Published var isNotificationEnabled = true
    
    init(){
        requestNotificationAuthorization()
    }
    
    //Func
    
    func openAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
    
    private func enableNotifications(){
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    private func disableNotifications(){
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
    private func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        center.requestAuthorization(options: options) { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    self.isNotificationEnabled = true
                }
            } else {
                DispatchQueue.main.async {
                    self.isNotificationEnabled = false
                }
            }
        }
    }
}

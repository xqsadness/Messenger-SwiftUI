//
//  LocalNotification.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 14/12/2023.
//

import Foundation
import UserNotifications
import SwiftUI

//Toast Message
class LocalNotification: ObservableObject {
    static var shared = LocalNotification()
    
    @Published var toastStatus: ToastStatus = .info
    
    func setLocalNotification(title: String, subtitle: String, body: String, when: Double, id: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: when, repeats: false)
        let request = UNNotificationRequest.init(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func message(_ str: String,_ status: ToastStatus?) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PushMessage"), object: nil, userInfo: ["data": str])
            self.toastStatus = status ?? .info
        }
    }
    
    static func message(_ str: String,_ status: ToastStatus?){
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PushMessage"), object: nil, userInfo: ["data": str])
            LocalNotification.shared.toastStatus = status ?? .info
        }
    }
}

enum ToastStatus {
    case success
    case error
    case info
    case warning
    
    func color() -> Color {
        switch self {
        case .success:
            return .green
        case .error:
            return .red
        case .info:
            return .blue
        case .warning:
            return .yellow
        }
    }
    
    func icon() -> String {
        switch self {
        case .success:
            return "checkmark.circle.fill"
        case .error:
            return "xmark.circle.fill"
        case .info:
            return "info.circle.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        }
    }
}

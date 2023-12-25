//
//  PushNotificationSender.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 25/12/2023.
//

import Foundation

class PushNotificationSender {
    static var shared = PushNotificationSender()
    
    func sendPushNotificationProduct(to token: String, title: String, body: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = URL(string: urlString)!
        let paramString: [String: Any] = [
            "notification": [
                "title": title,
                "body": body,
                "sound": "default"
            ],
            "to": token
        ]

        let jsonData = try? JSONSerialization.data(withJSONObject: paramString)
        
        var request = URLRequest(url: url)
        let key = "AAAAxSMaiqc:APA91bH3TqzOsBUUmu59B7Lz2KvXhaPtgDX9eUke8v3j-BmVYdAhVKk-WcI3Jxe0CFDvmT9wPtflYtOszuwprEe1eiXxHlNfrxvNw-aJxWB1BOtyhcj52PxkKUk0eIThhSsq3c3fBmH_"
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(key)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error sending push notification: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                do {
                    if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        NSLog("Received data:\n\(jsonData)")
                    }
                } catch {
                    print("Error parsing JSON response: \(error.localizedDescription)")
                }
            }
        }
        
        task.resume()
    }
}

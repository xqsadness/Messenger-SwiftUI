//
//  Appcontroller.swift
//  Instagram
//
//  Created by iamblue on 07/12/2023.
//

import Foundation
import SwiftUI

class AppController: ObservableObject{
    static var instance = AppController()
   
    @Published var SHOW_MESSAGE_ON_SCREEN = false
    @Published var MESSAGE_ON_SCREEN = ""
    @Published var TIMER_MESSAGE_ON_SCREEN: Timer?
}

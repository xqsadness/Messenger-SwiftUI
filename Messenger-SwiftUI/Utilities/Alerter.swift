//
//  Alerter.swift
//  Messenger-SwiftUI
//
//  Created by iamblue on 27/12/2023.
//

import SwiftUI

class Alerter: ObservableObject {
    static var shared = Alerter()
    @Published var alert: Alert? {
        didSet { isShowingAlert = alert != nil }
    }
    @Published var isShowingAlert = false
}
